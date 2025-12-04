provider "aws" {
  region = "us-east-1"
}

# 1. CloudWatch Billing Alarm
# Note: Billing metrics are stored in us-east-1 regardless of where resources are.
# You must enable "Receive Billing Alerts" in the AWS Billing Console preferences first.

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "billing-alarm-100-inr"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" # 6 hours
  statistic           = "Maximum"
  threshold           = "1.20" # Approx 100 INR in USD
  alarm_description   = "Alarm when AWS charges exceed $1.20 (approx 100 INR)"
  actions_enabled     = true

  dimensions = {
    Currency = "USD"
  }

  # alarm_actions = [aws_sns_topic.billing_alert.arn] # Uncomment if you have an SNS topic
}

# 2. AWS Budget (Free Tier / Zero Spend)
resource "aws_budgets_budget" "cost_budget" {
  name              = "monthly-budget-100-inr"
  budget_type       = "COST"
  limit_amount      = "1.20"
  limit_unit        = "USD"
  time_period_start = "2024-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["amarjeet@example.com"] # REPLACE with your email
  }
}
