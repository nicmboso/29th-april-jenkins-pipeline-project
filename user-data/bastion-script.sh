#!/bin/bash
echo "${tls_private_key.keypair.private_key_pem}" >> /home/ubuntu/.ssh/id_rsa
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chmod 600 /home/ubuntu/.ssh/id_rsa
sudo hostnamectl set-hostname bastion