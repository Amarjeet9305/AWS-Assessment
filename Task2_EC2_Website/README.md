# Task 2: EC2 Static Website Hosting

## Approach
I deployed a single EC2 instance in the public subnet created in Task 1. I used a Security Group to allow HTTP (port 80) traffic from anywhere and SSH (port 22) for management.
The instance is bootstrapped using `user_data` to:
1. Update the package manager.
2. Install Nginx.
3. Replace the default Nginx `index.html` with my custom static resume.
4. Start and enable the Nginx service.

I used `data` sources in Terraform to dynamically reference the VPC and Subnet ID from Task 1 by their tags, ensuring this task builds upon the previous network foundation without hardcoding IDs.

## Hardening Steps
- **Security Group**: Only opened ports 80 (HTTP) and 22 (SSH). In a production environment, SSH access should be restricted to a specific IP range (VPN or Office IP).
- **Private Subnet (Future)**: In a more secure setup (like Task 3), the web server would be in a private subnet behind a Load Balancer, with no direct SSH access from the internet (using Systems Manager Session Manager instead).
- **Minimal AMI**: Used a standard Ubuntu AMI.

## Deliverables
- **Terraform Code**: `main.tf`
- **Setup Script**: Embedded in `user_data` within `main.tf`.
- **Screenshots**:
    - [ ] EC2 Instance Dashboard showing the running instance.
    - [ ] Security Group Inbound Rules.
    - [ ] Browser screenshot showing the "Amarjeet's Resume" page accessed via Public IP.

## How to Deploy
1. **Prerequisite**: Ensure Task 1 is applied.
2. **Key Pair**: You need an existing Key Pair in us-east-1. Update `key_name = "my-key-pair"` in `main.tf` with your actual key name.
3. Run `terraform init`
4. Run `terraform apply`
5. Access the website using the `website_url` output.
