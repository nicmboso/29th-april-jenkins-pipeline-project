# Jenkins-Pipeline-Project

Introduction:
This project aims to create and deploy a Pet Adoption application written in Java on Docker containers and ensuring the application runs in a highly available, scalable, self-healing environment on AWS. The resources are deployed on AWS through Terraform code. The codes can be found on the team’s GitHub repo used for collaboration. Below gives the steps to the Terraform code used in this project to deploy the resources on AWS.

Project Architecture:
![29th-April-Jenkins-Pipeline-Project-EU-Team](https://github.com/nicmboso/29th-april-jenkins-pipeline-project/assets/160390032/6bca85c0-b7e2-41ce-a2a5-4699ed799ef8)

Tech Stack Used:
AWS, GitHub, Terraform, Maven, Jenkins, Ansible, Docker, SonarQube, Nexus, Bastion Host, NewRelic.

Prerequisites:
AWS account, AWS CLI, Git, Terraform

Deployment Steps:
1. Clone the App repo:
git clone https://github.com/CloudHight/Jenkins-pipeline-Project.git

2. Navigate to the Project directory to access the application:
cd Jenkins-pipeline-Project

3. Set up the resources with terraform in main.tf file
4. Ensure newrelic.yml file is updated with the following variables:

#!bin/bash
license_key: YOUR_LICENSE_KEY
agent_enabled: true
app_name: YOUR_APP_NAME

5. Run Terraform commands to initialize (to download the necessary providers or plugins with bash) and review the resources planned for deployment using bash:
#!bin/bash
terraform init
terrraform plan -var-file my-credentials.tfvars
terraform apply

6. Set up SonarQube for bugs, vulnerabilities, and code quality checks

7. Set up New Relic for monitoring

8. Set up Jenkins for Continuous Integration (CI) Pipeline

9. Run the Pipeline

10. Confirm the app has been deployed in a containerized environment

11. Check the app can be accessed via the load balancer or Route53 DNS name on the browser
