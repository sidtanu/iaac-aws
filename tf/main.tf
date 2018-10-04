terraform {
  backend "s3" {
    bucket         = "iaac-tfstates"
    region         = "us-west-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

resource "aws_security_group" "IAAC" {
  name = "${var.sg_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.sg_name}"
  }
}

resource "aws_instance" "IAAC" {
  count                  = "${var.count}"
  ami                    = "${data.aws_ami.amazon_linux.id}"
  availability_zone      = "us-west-2a"
  instance_type          = "t2.micro"
  key_name               = "aws-sid-key"
  vpc_security_group_ids = ["${aws_security_group.IAAC.id}"]
  
  root_block_device {
   #device_name = "/dev/sda1"
   volume_type = "gp2"
   volume_size = 20
  }
  
 }
