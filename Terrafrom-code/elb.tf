# Create a new load balancer
resource "aws_security_group" "test-devops-elb" {
  name        = "test-devops-elb"
  description = "Allow port 8080 and remote login publicly"
  vpc_id      = "<vpc-id>"

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name       = "test-devops-elb"
  }
}
resource "aws_elb" "assignment-elb" {
  name               = "assignment-elb"
  subnets =["<publis-subnet1>","<publis-subnet2>"]
  security_groups= ["${aws_security_group.test-devops-elb.id}"]
  #
  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #   interval      = 60
  # }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "tcp:80"
    interval            = 30
  }

  instances                   = ["${aws_instance.test-devops-app.id}"]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 100

  tags = {
    Name = "assignment-elb"
  }
}

resource "aws_route53_record" "assignment-elb_Route53" {
  zone_id = "XXXXXXXXXX"
  name    = "test-devops.assignment.in"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.assignment-elb.dns_name}"]
}
