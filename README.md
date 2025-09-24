This repo for infrastructure as code

# Description
This repository contains infrastructure as code (IaC) configurations using Terraform and Yandex Cloud (YC). It includes a playbook for deploying ArgoCD on Yandex Cloud.

# Usage
For yandex cloud: terraform/yc/README.md

# setup vagrant
## ubuntu/debian
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```
# setup ansible
```bash
sudo apt install python3-pip
pip3 install ansible
```

# run vagrant
vagrant up

# for vmware
1. setup package
2. setup plugin
