provider "aws" {
  region = "us-west-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "ssh_cidr_block" {
  default = "YOUR_IP_ADDRESS/32"  # replace with your IP for SSH access
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-YOUR-AMI-ID" # replace with your ami-id
}

variable "ssh_key_name" {
  default = "YOUR-SSH-KEYPAIR" # replace with your ssh key pair
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# config for VPC subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr_block
}

# config for security group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  // restrict SSH access to specific IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }

  // allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# config ssh key pair
resource "aws_key_pair" "my_keypair" {
  key_name   = var.ssh_key_name
  public_key = file("~/.ssh/id_rsa.pub") # default public key for linux, adjust as needed
}

# launching the instance
resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = aws_key_pair.my_keypair.key_name
  security_groups = [aws_security_group.my_security_group.id]

  // install software such as nginx
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }

  tags = {
    Name = "EC2Instance"
  }
}