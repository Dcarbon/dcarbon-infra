#!/bin/bash

sudo yum update -y
#NodeJS
echo "__________NodeJs and NPM setting__________"
curl -sL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs
sudo npm i -g yarn
sudo yum install jq -y
echo "__________Python3 setting__________"
sudo yum install python3 -y
python3 --version
echo "__________Serverless setting__________"
npm install -g serverless
#Git
echo "__________GIT setting__________"
yes | sudo yum install git
#Docker
echo "__________Docker setting__________"
yes | sudo yum install -y docker
sudo usermod -aG docker $USER
sudo systemctl start docker && sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock
docker images
echo "__________AWS setting__________"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
#Iptable
sudo yum install -y iptables-services
sudo systemctl enable iptables.service
#app-dir
sudo mkdir -p "/my-app/env/dev/dapp"
sudo mkdir -p "/my-app/env/dev/backend"
sudo mkdir -p "/my-app/env/dev/admin-backend"
sudo mkdir -p "/my-app/env/dev/admin"
sudo mkdir -p "/my-app/env/dev/snapshot"
sudo mkdir -p "/my-app/env/dev/common"

sudo mkdir -p "/my-app/env/beta/dapp"
sudo mkdir -p "/my-app/env/beta/backend"
sudo mkdir -p "/my-app/env/beta/admin-backend"
sudo mkdir -p "/my-app/env/beta/admin"
sudo mkdir -p "/my-app/env/beta/snapshot"
sudo mkdir -p "/my-app/env/beta/common"

sudo mkdir -p "/my-app/env/prod/dapp"
sudo mkdir -p "/my-app/env/prod/backend"
sudo mkdir -p "/my-app/env/prod/admin-backend"
sudo mkdir -p "/my-app/env/prod/admin"
sudo mkdir -p "/my-app/env/prod/snapshot"
sudo mkdir -p "/my-app/env/prod/common"
sudo chmod -R 777 "/my-app"
sudo cp -rf /tmp/env /my-app
#Jenkins
echo "__________Jenkins setting__________"
sudo dnf install -y java-11-amazon-corretto-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo yum install jenkins -y
sudo usermod -a -G docker jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
echo "__________Output: Jenkins password setting__________"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo systemctl start iptables
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
sudo iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
sudo sh -c "iptables-save > /etc/iptables.rules"
sudo /usr/libexec/iptables/iptables.init save
echo "__________Jenkins SSH Git setting__________"
sudo su -s /bin/bash jenkins -c 'mkdir ~/.ssh && cd ~/.ssh && ssh-keygen -t ed25519 -C "longld@fabbi.com.vn" -f id_ed25519 -q -P "" && eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519 && ssh-keyscan fabbi.git.backlog.com >> ~/.ssh/known_hosts && echo "__________Output: Jenkins SSH Public Key__________: " && cat id_ed25519.pub'
echo "__________FINISHED__________"
