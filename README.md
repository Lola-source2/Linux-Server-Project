# Terraform Azure Linux VM Deployment with Secure Web Server

** Project Overview **

This project provisions a secure and automated infrastructure on Microsoft Azure using Terraform. It deploys a Linux Virtual Machine configured with an Nginx web server using a custom initialization script.

The infrastructure is designed following basic security and automation best practices, including SSH key authentication, network security controls, enabling secure access through Azure Bastion and automated server configuration.

# Business Problem 

Many small and growing businesses face challenges when deploying web applications:

Manual server setup is slow and error-prone
Inconsistent configurations across environments
Weak security (e.g., password-based SSH access)
Lack of scalable and repeatable infrastructure
Lack of controlled administrative access


# Solution 

This project solves these problems by:

Automating infrastructure provisioning using Terraform
Using Azure Bastion as a secure access gateway
Enforcing secure access via SSH key authentication
Restricting network traffic using Network Security Groups (NSG)
Automatically configuring a web server using a custom script

This ensures:

Faster deployment
Improved security posture
Consistent and repeatable environments
Reduced operational overhead
Improved security (no direct internet exposure)
Controlled and auditable access


# Architecture

The following components are provisioned:

Resource Group  -> rg
Virtual Network -> "192.168.0.0/16"
Subnet -> "192.168.1.0/24"
Azure Bastion Subnet (AzureBastionSubnet 192.168.2.0/26)
Network Security Group (NSG)
Allows:
SSH (Port 22)
HTTP (Port 80)
Public IP (for Bastion only)
Azure Bastion Host
Network Interface (NIC)
Linux Virtual Machine
Ubuntu-based
SSH key authentication (passwordless login)
Custom Script Extension
Installs and configures Nginx
Deploys a web page

# Security Features

VM has no public IP (fully private)
Secure access via Azure Bastion
SSH key-based authentication (no passwords)
NSG rules restricting inbound traffic
Least privilege sudo configuration 
Secure file permissions for SSH


# Technologies Used

Terraform (Infrastructure as Code)
Microsoft Azure
Linux (Ubuntu)
Nginx Web Server


# Deployment Steps
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
