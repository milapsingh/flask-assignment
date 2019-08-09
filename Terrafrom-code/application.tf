provider "aws" {
  region  = "region"
  profile = "<name>"
}

resource "aws_security_group" "test-devops" {
  name        = "test"
  description = "Allow port 8080 and remote login publicly"
  vpc_id      = "<vpc-id>"

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags ={
    Name       = "test-devops"
  }
}

resource "aws_instance" "test-devops-app" {
  ami           = "ami-009110a2bf8d7dd0a"
  instance_type = "t2.large"
  key_name      = "<name>"
  subnet_id     = "<private-subnet_id>"
  user_data = "${file("install.sh")}"
  tags = {

    Name       = "test-devops-app"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  vpc_security_group_ids = ["${aws_security_group.test-devops.id}"]
}
