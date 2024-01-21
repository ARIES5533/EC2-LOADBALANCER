
# AWS Multi-Client Load Balancer Infrastructure with Terraform

## Overview

This Terraform script automates the deployment of a scalable and secure AWS infrastructure that includes an Application Load Balancer (ALB) serving multiple clients. Each client is associated with a unique subdomain, and their traffic is directed to individual instances through target groups. The infrastructure also includes necessary networking components, security groups, and certificate management.


## Table of Contents

- [Description](#description)
- [Features](#features)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Variables](#variables)
- [Providers](#providers)
- [Terraform Backend](#terraform-backend)
- [Contributing](#contributing)
- [License](#license)

## Description
The infrastructure includes:

- Amazon VPC with specified subnets
- Amazon Load Balancer with HTTPS and HTTP listeners
- AWS instances for each client
- AWS ACM certificates for HTTPS communication
- AWS Security Groups to control inbound and outbound traffic

The project is organized into modules and resources to ensure maintainability and scalability.

## Features

- **Scalability:** Easily scale the infrastructure to accommodate additional clients by updating the `clients` variable.
- **Security:** Utilizes AWS Security Groups to control inbound and outbound traffic.
- **Load Balancing:** Distributes incoming traffic across multiple instances to ensure high availability.
- **HTTPS Support:** Configures HTTPS listeners and uses ACM certificates for secure communication.

## Getting Started

To deploy the SeamlessARIES infrastructure, follow these steps:

1. Clone this repository: `git clone <repository-url>`
2. Install Terraform (version ~> 0.12)
3. Configure AWS credentials using `aws configure`
4. Update variables in `variables.tf` to match your specific environment.
5. Run `terraform init` to initialize the Terraform configuration.
6. Run `terraform apply` to create the infrastructure.

## Project Structure

- **main.tf:** Defines the main infrastructure components like VPC, Load Balancer, instances, and listeners.
- **variables.tf:** Contains input variables used to customize the infrastructure.
- **providers.tf:** Configures the AWS provider with access and secret keys.
- **backend.tf:** Configures the Terraform backend for state management.
- **modules/acm:** Contains a reusable ACM module for creating SSL certificates.
- **.gitignore:** Specifies files and directories to be ignored by version control.

## Variables

- **clients:** A list of objects containing client details such as client name and subdomain.
- **instance_profile:** IAM instance profile for instances.
- **ami:** Amazon Machine Image (AMI) ID for instances.
- **key:** SSH key name for instances.
- **subnet-1:** Subnet ID for the first subnet.
- **subnet-2:** Subnet ID for the second subnet.
- **vpc_name:** Name of the VPC.
- **security_group:** ID of the existing AWS Security Group.

## Providers

- **aws:** Configures the AWS provider with the specified version.

## Terraform Backend

Terraform state is stored remotely using an S3 backend with DynamoDB for state locking. Update the `backend.tf` file with your S3 bucket and DynamoDB table details.
