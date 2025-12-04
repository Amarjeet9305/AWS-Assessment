provider "aws" {
  region = "us-east-1"
}

variable "project_name" {
  default = "Amarjeet_Assessment"
}

# Data Sources
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}_VPC"]
  }
}

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}_Public_Subnet_1"]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}_Public_Subnet_2"]
  }
}

data "aws_subnet" "private_1" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}_Private_Subnet_1"]
  }
}

data "aws_subnet" "private_2" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}_Private_Subnet_2"]
  }
}

# 1. Security Groups
# ALB Security Group (Allow HTTP from anywhere)
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}_ALB_SG"
  description = "Allow HTTP to ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_ALB_SG"
  }
}

# Instance Security Group (Allow HTTP only from ALB)
resource "aws_security_group" "instance_sg" {
  name        = "${var.project_name}_Instance_SG"
  description = "Allow HTTP from ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_Instance_SG"
  }
}

# 2. Application Load Balancer
resource "aws_lb" "main" {
  name               = "amarjeet-alb" # Must be unique/valid chars
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]

  tags = {
    Name = "${var.project_name}_ALB"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "amarjeet-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# 3. Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "amarjeet-lt-"
  image_id      = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo '<h1>Amarjeet Resume - High Availability Demo</h1><p>Served from hostname: $(hostname)</p>' > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}_ASG_Instance"
    }
  }
}

# 4. Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  name                = "amarjeet-asg"
  vpc_zone_identifier = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id]
  target_group_arns   = [aws_lb_target_group.main.arn]
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}_ASG_Instance"
    propagate_at_launch = true
  }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
