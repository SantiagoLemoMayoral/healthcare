resource "aws_lb" "main" {
  name = "healthcare-alb"
  load_balancer_type = "application"
  internal = false

  security_groups = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b
  ]
}

resource "aws_lb_listener" "name" {
   load_balancer_arn = aws_lb.main.id
   port = 80
   protocol = "HTTP"
  
   default_action {
     type = "forward"
     target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "app" {
  name     = "healthcare-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  target_type = "instance"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.name.id
  target_id = aws_instance.app.id
  port = 8000
}