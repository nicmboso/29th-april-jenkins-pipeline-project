#Installing Docker Instance

#!/bin/bash

#updatng the instance
sudo yum update -y
sudo yum upgrade -y

#install docker
sudo yum install -y yum-utils
sudo yum config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo #downloads & adds repo to instance
sudo yum install docker-ce -y


#start docker
sudo systemctl start docker
sudo systemctl enable docker

#add the ec2-user to the docker group
sudo usermod -aG docker ec2-user   

#install newrelic
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | \
bash && sudo NEW_RELIC_API_KEY="${newrelic-license-key}" NEW_RELIC_ACCOUNT_ID="${acct-id}" \
NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y

#setting the host name
sudo hostnamectl set-hostname Docker

# curl -o /tmp/newrelic-infra.rpm https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra-1.11.39-1.el7.x86_64.rpm
# sudo hostnamectl set-hostname Docker
# sudo rpm -i /tmp/newrelic-infra.rpm
# sudo sed -i -e 's/license_key: .*/license_key: YOUR_LICENSE_KEY/' /etc/newrelic.yml
# sudo systemctl start newrelic-infra
EOF
}

  