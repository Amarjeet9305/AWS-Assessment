# Task 5: AWS Architecture Diagram

## Scenario
"Design an AWS architecture for a highly scalable web application capable of handling 10,000 concurrent users."

## Architecture Explanation
To handle 10,000 concurrent users, I designed a **Multi-Tier Architecture** focused on scalability, high availability, and security.
- **Frontend**: Traffic enters via **Route 53** and is inspected by **AWS WAF** before hitting an **Internet-Facing ALB**. Static assets are offloaded to **S3** and cached globally via **CloudFront** to reduce server load.
- **Application Layer**: An **Auto Scaling Group (ASG)** of EC2 instances in private subnets handles the application logic. This ensures capacity adjusts automatically based on demand (CPU/Memory).
- **Data Layer**: A **Multi-AZ RDS** (Aurora or PostgreSQL) ensures data durability and high availability. **ElastiCache (Redis)** is implemented to cache frequent database queries, significantly improving read performance and reducing database load.
- **Security & Observability**: Resources are isolated in private subnets with strict **Security Groups**. **CloudWatch** monitors metrics and logs, while **NACLs** provide subnet-level security.

## Architecture Diagram
(You can recreate this in draw.io using the components below)

```mermaid
graph TD
    subgraph "AWS Cloud"
        subgraph "VPC"
            subgraph "Public Subnets"
                ALB[Application Load Balancer]
                NAT[NAT Gateway]
            end
            
            subgraph "Private Subnets (App Tier)"
                ASG[Auto Scaling Group<br/>(EC2 Instances)]
            end
            
            subgraph "Private Subnets (Data Tier)"
                RDS[(RDS Multi-AZ)]
                Redis[(ElastiCache Redis)]
            end
        end
        
        WAF[AWS WAF]
        IGW[Internet Gateway]
        CW[CloudWatch]
    end
    
    User((User)) -->|HTTPS| R53[Route 53]
    R53 -->|Alias| CF[CloudFront]
    R53 -->|Alias| WAF
    WAF --> ALB
    CF --> S3[S3 Bucket<br/>(Static Assets)]
    
    ALB -->|Traffic| ASG
    ASG -->|Read/Write| RDS
    ASG -->|Cache| Redis
    ASG -->|Outbound| NAT
    NAT --> IGW
    
    classDef aws fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:white;
    class ALB,NAT,ASG,RDS,Redis,WAF,IGW,S3,R53,CF,CW aws;
```

## Deliverables
- **Diagram**: See the Mermaid diagram above.
- **Draw.io File**: Please create a diagram in draw.io based on the structure above and save it as `architecture_diagram.png` in this folder.
