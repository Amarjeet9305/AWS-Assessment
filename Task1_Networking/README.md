# Task 1: Networking & Subnetting (AWS VPC Setup)

## Approach
I designed a custom Virtual Private Cloud (VPC) to provide a secure and isolated network environment. The architecture follows AWS best practices by separating resources into public and private subnets across two Availability Zones (AZs) for high availability.

- **VPC**: Created with a CIDR block of `10.0.0.0/16` to allow for a large number of IP addresses (65,536), providing flexibility for future growth.
- **Public Subnets**: Hosted in separate AZs (`us-east-1a`, `us-east-1b`) with direct access to the Internet via an Internet Gateway (IGW). These are intended for resources that need to be publicly accessible, like Load Balancers or Bastion Hosts.
Step1 Create VPC:
![
    
](<Screenshot (544).png>)

Step 2 Successfull
![alt text](<Screenshot (546).png>)


- **Private Subnets**: Hosted in the same two AZs but without direct internet access. Outbound internet connectivity is provided via a NAT Gateway located in a public subnet. This ensures secure updates and API calls for private resources (like databases or application servers) without exposing them to incoming internet traffic.

- **Route Tables**: configured separate route tables for public and private subnets to control traffic flow.

## CIDR Ranges
| Resource | CIDR Range | Reason |
|----------|------------|--------|
| **VPC** | `10.0.0.0/16` | Standard large block for a new network environment. |
| **Public Subnet 1** | `10.0.1.0/24` | 256 IPs. Sufficient for public 

![alt text](<Screenshot 2025-12-04 133155.png>)

facing components. |
| **Public Subnet 2** | `10.0.2.0/24` | 256 IPs. Distinct range for the 
![alt text](<Screenshot 2025-12-04 133235.png>)
second AZ. |
| **Private Subnet 1** | `10.0.3.0/24` | 256 IPs. For backend resources in 

AZ 1. |
| **Private Subnet 2** | `10.0.4.0/24` | 256 IPs. For backend resources in AZ 2. |
![
    
](<Screenshot 2025-12-04 133259.png>)

## Deliverables
- **Terraform Code**: See `main.tf` in this directory.
- **Screenshots**: (Please capture these after applying the Terraform code)
    - [ ] VPC Dashboard showing the new VPC
    - [ ] Subnets list showing all 4 subnets
    - [ ] Route Tables showing associations and routes
    - [ ] NAT Gateway and Internet Gateway details

    ![alt text](<Screenshot 2025-12-04 133430.png>)

## How to Deploy
1. Open a terminal in this directory.
2. Run `terraform init`
3. Run `terraform apply` and type `yes` to confirm.
4. Once done, take the required screenshots from the AWS Console.
5. **IMPORTANT**: Run `terraform destroy` when finished to avoid costs.
 Step 4 Final VPC Successfully 
 ![alt text](<Screenshot 2025-12-04 132848.png>)
