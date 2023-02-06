provider "aws" {
  region = "us-east-1"
}

// Creating Ec2 instance
resource "aws_instance" "webapp_server" {
  ami           = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.micro"
  subnet_id            = aws_subnet.public_subnet.id
  iam_instance_profile = "LabInstanceProfile"
  security_groups      = [aws_security_group.webapp_sg_assign1.id]
  key_name = "clo835-assign1"
  tags = {
    Name = "webapp-server"
  }
 
}

//Default VPC
data "aws_vpc" "default" {
  default = true
}

// For Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.96.0/20"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet"
  }
}


// Creation of ECR of application
resource "aws_ecr_repository" "application_ecr_repo" {
  name = "application_ecr_repo"
}

// Creation of ECR of database
resource "aws_ecr_repository" "database_ecr_repo" {
  name = "database_ecr_repo"
}

// Creation of Security group
resource "aws_security_group" "webapp_sg_assign1" {
  name        = "webapp-security-group-assign1"
  description = "Security group for webapp server"
  vpc_id      = data.aws_vpc.default.id
  
//opening ssh for coonecting to ec2 via ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

//Three ports for 3 conatiners of our application
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
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
      Name = "webapp-security-group-assign1"
  }
}



