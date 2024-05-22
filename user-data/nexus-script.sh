#!/bin/bash
sudo yum update -y
#install java and wget
sudo yum install wget -y
sudo yum install java-1.8.0-openjdk.x86_64 -y
#make a directory and switch to it
sudo mkdir /app && cd /app
#download nexus package from the internet
sudo wget http://download.sonatype.com/nexus/3/nexus-3.23.0-03-unix.tar.gz
#untar the package to reveal the folders and binaries in it
sudo tar -xvf nexus-3.23.0-03-unix.tar.gz
#rename the folder untared
sudo mv nexus-3.23.0-03 nexus
#create a nexus user
sudo adduser nexus
#change ownsership of the binary files from root to the nexus user created
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work
#edit the configure to always start the nexus service with the nexus user created
sudo cat <<EOT> /app/nexus/bin/nexus.rc
run_as_user="nexus"
EOT
#update the nexus.vmoptions file
sed -i '2s/-Xms2703m/-Xms512m/' /app/nexus/bin/nexus.vmoptions
sed -i '3s/-Xmx2703m/-Xmx512m/' /app/nexus/bin/nexus.vmoptions
sed -i '4s/-XX:MaxDirectMemorySize=2703m/-XX:MaxDirectMemorySize=512m/' /app/nexus/bin/nexus.vmoptions
#create the nexus.service file that will be used to start and stop nexus
sudo touch /etc/systemd/system/nexus.service
sudo cat <<EOT> /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOT
#create a soft link between the nexus binary file and init.d
sudo ln -s /app/nexus/bin/nexus /etc/init.d/nexus
#enable and start the nexus service
sudo chkconfig --add nexus
sudo chkconfig --levels 345 nexus on
sudo service nexus start
#install newrelic agent
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo  NEW_RELIC_API_KEY="${newrelic-license-key}" NEW_RELIC_ACCOUNT_ID="${acct-id}" NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y
#change Hostname(IP) to something readable
sudo hostnamectl set-hostname Nexus