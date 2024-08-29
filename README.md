# TekSystemsChallenge
This is Damola Kembi's Solution to 2nd Technical Interview.

**This file explains the repository and explanation of the scripts used for this solution**

The **Kubernetes** folder contains the 'deployment.yml' configuration file for Task 2 in Part 1. 
For the 'securityContext' settings, I have used 3 parameters:
1. "runAsNonRoot: true", which specifies the container proccess to run with a non-root user.
2. "runAsUser: 999", which specifies the user id to run the container process.
3. "readOnlyRootFilesystem: true", which specifies the root file system to be read-only, so ti can not be written into.


The **Dockerfile** contains solution for Task 1 in Part 1.


The **Web-Server-TF** folder contains terraform files for Task 1 in Part 2.
The "provider.tf" file specifies the provider, which is AWS.
The "vpc.tf" specifies the vpc, subnet, internet gateway, security group, and route table configurations.
The "variable.tf" and "variable.tfvars" specifies the variables.
The "backend.tf" file specifies the backend s3 configuration for the terrafrom state file
The "webserver-install.sh" contains the script to install apache webserver on the ec2 instance


The **Jenkinsfile** file contains Jenkins pipeline configuration for Task 2 in Part 2.
The "ansible-hardening.yml" and "inventory.ini" file are the ansible playbook and inventory configuration files respectively, used in the Jenkins file in the 'Ansible Hardening' stage.
