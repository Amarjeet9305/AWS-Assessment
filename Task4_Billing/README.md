# Task 4: Billing & Free Tier Cost Monitoring

## Approach
Cost monitoring is crucial for beginners to avoid unexpected charges. I implemented two layers of protection:
1. **CloudWatch Billing Alarm**: Triggers when the estimated charges exceed $1.20 (approx ₹100). This uses the `AWS/Billing` metric.
2. **AWS Budget**: A budget set to $1.20 that sends an email alert when actual spend exceeds 80% of the budget.

## Why Cost Monitoring is Important
- **Prevent Surprise Bills**: Cloud resources are pay-as-you-go. Leaving a large instance running or forgetting to delete a NAT Gateway can lead to significant costs.
- **Learning Safety**: It gives beginners confidence to experiment, knowing they will be alerted if they step out of the Free Tier or low-cost limits.
- **Resource Management**: Helps identify unused or "zombie" resources that are still incurring costs.

## Causes of Sudden Increases
- **NAT Gateways**: Hourly charge + data processing fees.
- **Public IPv4 Addresses**: AWS now charges for public IPv4 addresses.
- **EBS Volumes**: Unattached volumes still cost money.
- **Data Transfer**: Outbound data transfer can be expensive if traffic is high.
- **Leaving Resources Running**: Forgetting to stop EC2 instances or RDS databases.

## Deliverables
- **Terraform Code**: `main.tf`
- **Screenshots**:
    - [ ] **Billing Alarm**: Go to CloudWatch > Alarms and screenshot the `billing-alarm-100-inr`.
    - [ ] **Free Tier Usage Alerts**: Go to Billing Dashboard > Billing Preferences > Alert Preferences. Screenshot the "Receive Free Tier Usage Alerts" checkbox (this must be enabled manually in the console).

## How to Deploy
1. **Prerequisite**: Enable "Receive Billing Alerts" in the AWS Billing Console (Account > Billing preferences).
2. Update `subscriber_email_addresses` in `main.tf` with your actual email.
3. Run `terraform init`
4. Run `terraform apply`
