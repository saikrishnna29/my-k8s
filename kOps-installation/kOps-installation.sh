#Installation of k8s cluster using kOps for private dns hosted zone with Route 53

#Installing kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops
kops version

#To store the state(configuration) of our cluster in s3 
aws s3 mb s3://clusters.dev.my-k8s.com --region ap-south-1
export KOPS_STATE_STORE=s3://clusters.dev.my-k8s.com


#Installing kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

#Installing docker
sudo yum install -y docker
ssh-keygen

#Creating k8s cluster
kops create cluster \ 
    --zones=ap-south-1b apsouth1.dev.my-k8s.com \ 
    --dns-zone=my-k8s.com \ 
    --dns private \ 
    --master-count 3 \ 
    --node-count 1 \ 
    --node-size t2.small \ 
    --master-size t2.small \ 
    --yes

kops validate cluster
kops update cluster --name apsouth1.dev.my-k8s.com --yes
kops rolling-update cluster
kops edit cluster apsouth1.dev.my-k8s.com #To edit cluster for example adding additional zones
kops edit ig --name apsouth1.dev.my-k8s.com nodes-ap-south-1b #To scale our nodes
ssh -i ~/.ssh/id_rsa ubuntu@api.apsouth1.dev.my-k8s.com #To login to the master node
kubectl get nodes #Will list out the nodes 