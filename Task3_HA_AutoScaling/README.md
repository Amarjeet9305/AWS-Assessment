# Task 3: High Availability + Auto Scaling

## Approach
I enhanced the architecture to be highly available and scalable by introducing an Application Load Balancer (ALB) and an Auto Scaling Group (ASG).

- **Application Load Balancer (ALB)**: Deployed in the public subnets across two Availability Zones. It acts as the single entry point for traffic, distributing requests to healthy instances.
- **Auto Scaling Group (ASG)**: Manages a fleet of EC2 instances in the **private subnets**. This ensures that the application servers are not directly exposed to the internet, enhancing security.
- **Launch Template**: Defines the instance configuration (AMI, Instance Type, Security Groups, User Data). I updated the User Data to include the hostname in the HTML to demonstrate load balancing (you can see which instance served the request).
- **Security Groups**:
    - **ALB SG**: Allows HTTP (80) from anywhere (`0.0.0.0/0`).
    - **Instance SG**: Allows HTTP (80) **only** from the ALB Security Group. This creates a secure "tier" where instances only talk to the load balancer.

## Traffic Flow
1. User accesses the ALB DNS Name.
2. ALB receives the request on Port 80.
3. ALB forwards the request to one of the healthy instances in the Target Group (in Private Subnets).
4. Instance processes the request and returns the response via the ALB.

## Deliverables
- **Terraform Code**: `main.tf`
- **Screenshots**:
    - [ ] ALB Console showing the Load Balancer.
    - [ ] Target Group showing healthy targets.
    - [ ] Auto Scaling Group details (Desired: 2, Min: 2, Max: 4).
    - [ ] EC2 Instances Dashboard showing 2 instances created by the ASG.

## How to Deploy
1. **Prerequisite**: Task 1 must be applied (VPC/Subnets must exist).
2. Run `terraform init`
3. Run `terraform apply`
4. Access the application using the `alb_dns_name` output. Refresh the page multiple times to see if the hostname changes (indicating load balancing).
