provider "aws" {
  region = "us-east-1"
}

variable "project_name" {
  default = "Amarjeet_Assessment"
}

# Data Sources to fetch resources from Task 1
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

# 1. Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}_Web_SG"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Best practice: Restrict to your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_Web_SG"
  }
}

# 2. EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1 (Check for latest)
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.public_1.id
  security_groups = [aws_security_group.web_sg.id]
  key_name      = "my-key-pair" # REPLACE with your actual key pair name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo '${file("${path.module}/index.html")}' > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "${var.project_name}_Web_Server"
  }
}

output "website_url" {
  value = "http://${aws_instance.web_server.public_ip}"
}
