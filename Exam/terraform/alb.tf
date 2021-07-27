### --- === ALB === --- ###

resource "aws_lb" "rumiantsau_alb_go" {
  name               = "rumiantsau-alb-go"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rumiantsau_go_access.id]
  subnets            = aws_subnet.rumiantsau_public_subnets.*.id
  tags               = merge ({"Name" ="rumiantsau-alb-go"}, local.tags)
}

resource "aws_lb" "rumiantsau_alb_python" {
  name               = "rumiantsau-alb-python"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rumiantsau_python_access.id]
  subnets            = aws_subnet.rumiantsau_public_subnets.*.id
  tags               = merge ({"Name" ="rumiantsau-alb-python"}, local.tags)
}

resource "aws_lb_listener" "rumiantsau_alb_listener-go" {
  load_balancer_arn = aws_lb.rumiantsau_alb_go.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rumiantsau_alb_tg_go.arn
  }
}

resource "aws_lb_listener" "rumiantsau_alb_listener-python" {
  load_balancer_arn = aws_lb.rumiantsau_alb_python.arn
  port              = "8181"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rumiantsau_alb_tg_python.arn
  }
}

resource "aws_lb_target_group" "rumiantsau_alb_tg_go" {
  name     = "rumiantsau-alb-tg-go"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.rumiantsau_vpc.id
}

resource "aws_lb_target_group" "rumiantsau_alb_tg_python" {
  name     = "rumiantsau-alb-tg-python"
  port     = 8181
  protocol = "HTTP"
  vpc_id   = aws_vpc.rumiantsau_vpc.id
}

resource "aws_lb_target_group_attachment" "rumiantsau_alb_target_group_attachment_go" {
  target_group_arn = aws_lb_target_group.rumiantsau_alb_tg_go.arn
  target_id        = data.aws_instance.ecs_instance.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "rumiantsau_alb_target_group_attachment_python" {
  target_group_arn = aws_lb_target_group.rumiantsau_alb_tg_python.arn
  target_id        = data.aws_instance.ecs_instance.id
  port             = 8181
}

data "aws_instance" "ecs_instance" {
  depends_on  = [aws_launch_configuration.rumiantsau_ecs_launch_config]
  filter {
    name   = "image-id"
    values = [data.aws_ami.ecs_optimized.id]
  }
    tags   = merge ({"Name" = "rumiantsau-ecs_instance"}, local.tags) 
}