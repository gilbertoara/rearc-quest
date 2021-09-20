provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "C:/.aws/credentials"
  profile = "aws-profile"
}

resource "aws_instance" "web01" {
    ami = "ami-087c17d1fe0178315"
    instance_type = "t2.micro"
    key_name = "rearc-quest"
      tags = {
        Name = "rearc-lab-web01"
  }
}


resource "aws_alb" "alb01" {
  name               = "rearc-lab-alb01"
  load_balancer_type = "application"
  subnets            = ["subnet-52b9c55e", "subnet-904f39bc"]

  enable_deletion_protection = false
  tags = {
    Description = "Rearc-Lab"
  }  
}

resource "aws_lb_target_group" "front_end" {
  name     = "rearc-tg-web01"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-f23d7c8b"
  health_check {
    matcher  = "200,302,301"
    port     = "2323"
    path     = "/"
    protocol = "HTTP"
  }
  
}

resource "aws_lb_target_group_attachment" "front_end" {
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = aws_instance.web01.id
  port             = 2323
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb01.arn
  port              = "2323"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_listener" "https-listener" {
  load_balancer_arn = aws_alb.alb01.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "arn:aws:acm:us-east-1:407078168251:certificate/5e7c9021-c00d-40c8-9139-7a84718fc072"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}