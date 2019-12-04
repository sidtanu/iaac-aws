

provider "aws" {
  region = "us-east-1"
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
  
}

resource "aws_instance" "IAAC" {
  ami                    = "ami-0c6956b16616620ef"
  availability_zone      = "us-east-1a"
  instance_type          = "t2.micro"
  key_name               = "aws-sid-key"
  vpc_security_group_ids = ["${aws_security_group.IAAC.id}"]
  
  root_block_device {
   #device_name = "/dev/sda1"
   volume_type = "gp2"
   volume_size = 20
  }
  
 }
