#!/bin/bash

sudo yum update -y
sudo dnf install -y ansible-core python3 python3-pip
sudo yum install -y yum utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
echo "${tls_private_key.keypair.private_key_pem}" >> /home/ec2-user/.ssh/id_rsa
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
chmod 400 id_rsa /home/ec2-user/.ssh/id_rsa
sudo chown -R ec2-user:ec2-user /opt/docker
sudo chmod -R 700 /opt/docker
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=ENTER KEY HERE NEW_RELIC_ACCOUNT_ID=ENTER ID HERE NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y
sudo hostnamectl set-hostname Ansible   
