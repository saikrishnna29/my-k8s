#!/bin/bash

#Installing loki-stack on Amazon Linux 2

sudo yum update -y 
wget https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz && 
tar -xvzf helm-v3.8.0-linux-amd64.tar.gz && 
sudo mv linux-amd64/helm /usr/local/bin && 
helm version
if [ $? -eq "0" ]
then
echo "*** Helm 3.8.0 is installed successfully ***"
else 
echo "*** Failed to install helm ***"
fi

#Installing eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && 
sudo mv /tmp/eksctl /usr/local/bin
if [ $? -eq "0" ]
then
echo "*** eksctl is installed successfully ***"
else 
echo "*** Failed to install eksctl ***"
fi

#Installing kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl && 
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client 
if [ $? -eq "0" ]
then
echo "*** kubectl is installed successfully ***"
else
echo "*** Failed to install kubectl ***"
fi

#Setup k8s cluster
#Installing loki with helm
helm repo add grafana https://grafana.github.io/helm-charts && 
helm repo update && 
helm search repo grafana 
helm show values grafana/loki-stack >> $PWD/loki-stack-values.yaml # Edit the values for custom options
#grafana username-admin and password can be found by running kubectl get secret -n loki loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
