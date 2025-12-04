# AWS Technical Assessment - Amarjeet

This repository contains the solutions for the AWS Technical Assessment.

## Repository Structure
- **[Task 1: Networking & Subnetting](./Task1_Networking)**
  - Terraform code for VPC, Public/Private Subnets, IGW, and NAT Gateway.
- **[Task 2: EC2 Static Website Hosting](./Task2_EC2_Website)**
  - Terraform code to deploy an Nginx web server on EC2 with a static resume.
- **[Task 3: High Availability + Auto Scaling](./Task3_HA_AutoScaling)**
  - Terraform code for ALB, Auto Scaling Group, and Launch Template.
- **[Task 4: Billing & Free Tier Cost Monitoring](./Task4_Billing)**
  - Terraform code for CloudWatch Billing Alarms and AWS Budgets.
- **[Task 5: AWS Architecture Diagram](./Task5_Architecture)**
  - Architecture explanation and diagram for a scalable web application.

## Prerequisites
- AWS Account (Free Tier)
- Terraform installed
- AWS CLI configured with credentials

## How to Deploy
Navigate to each task folder and run:
1. `terraform init`
2. `terraform apply`

**Note**: Remember to run `terraform destroy` after verifying the resources to avoid costs.
