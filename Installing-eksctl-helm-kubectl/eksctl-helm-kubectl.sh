sudo yum update -y
#Installs helm 3.8.0
wget https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz \ 
 && tar -xvzf helm-v3.8.0-linux-amd64.tar.gz \ 
 && mv linux-amd64/helm /usr/local/bin
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \ 
 && sudo mv /tmp/eksctl /usr/local/bin
#Installs k8s 1.21.2 version
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl \ 
 && chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin 
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc