### --- === VPC === --- ###

data "aws_availability_zones" "available_zones_in_current_region" {
  state                   = "available"
}

resource "aws_vpc" "rumiantsau_environment_vpc" {
  cidr_block              = var.vpc_network
  enable_dns_hostnames    = true
  tags               = merge (
                    {"Name" = "rumiantsau-environment-vpc"}, local.tags
                          )  
}

### --- === Subnets === --- ###

resource "aws_subnet" "rumiantsau_environment_private_subnets" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.rumiantsau_environment_vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available_zones_in_current_region.names[count.index]
  map_public_ip_on_launch = "true"
    tags               = merge (
                    {"Name" = "rumiantsau-environment-private-subnets-${count.index+1}"}, local.tags
                          )  
 }

resource "aws_subnet" "rumiantsau_environment_public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.rumiantsau_environment_vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available_zones_in_current_region.names[count.index]
  map_public_ip_on_launch = "true"
      tags               = merge (
                    {"Name" = "rumiantsau-environment-public-subnets-${count.index+1}"}, local.tags
                          )  
}

### --- === Internet gateway === --- ###

resource "aws_internet_gateway" "rumiantsau_environment_igw" {
  vpc_id                  = aws_vpc.rumiantsau_environment_vpc.id
        tags               = merge (
                    {"Name" = "rumiantsau-environment-igw"}, local.tags
                          )  
}

### --- === Route tables === --- ###

resource "aws_route_table" "rumiantsau_environment_vpc_public_route_table" {
  vpc_id = aws_vpc.rumiantsau_environment_vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.rumiantsau_environment_igw.id
  }
          tags               = merge (
                    {"Name" = "rumiantsau-environment-vpc-public-route-table"}, local.tags
                          )  
}

resource "aws_route_table" "rumiantsau_environment_vpc_private_route_table" {
  vpc_id                  = aws_vpc.rumiantsau_environment_vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    instance_id           = aws_instance.rumiantsau_environment_nat_instance.id
  }
  depends_on              = [aws_instance.rumiantsau_environment_nat_instance]
            tags               = merge (
                    {"Name" = "rumiantsau-environment-vpc-private-route-table"}, local.tags
                          )  
}

### --- === Route tables association === --- ###

resource "aws_route_table_association" "associate_public_subnets_with_public_route_table1" {
  subnet_id               = aws_subnet.rumiantsau_environment_public_subnets[0].id
  route_table_id          = aws_route_table.rumiantsau_environment_vpc_public_route_table.id
}

resource "aws_route_table_association" "associate_public_subnets_with_public_route_table2" {
  subnet_id               = aws_subnet.rumiantsau_environment_public_subnets[1].id
  route_table_id          = aws_route_table.rumiantsau_environment_vpc_public_route_table.id
}

resource "aws_route_table_association" "associate_private_subnets_with_private_route_table1" {
  subnet_id               = aws_subnet.rumiantsau_environment_private_subnets[0].id
  route_table_id          = aws_route_table.rumiantsau_environment_vpc_private_route_table.id
}

resource "aws_route_table_association" "associate_private_subnets_with_private_route_table2" {
  subnet_id               = aws_subnet.rumiantsau_environment_private_subnets[1].id
  route_table_id          = aws_route_table.rumiantsau_environment_vpc_private_route_table.id
}

### --- === ALB === --- ###

resource "aws_lb" "rumiantsau_environment_alb" {
  name               = "rumiantsau-environment-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rumiantsau_environment_web_access.id]
  subnets            = aws_subnet.rumiantsau_environment_private_subnets.*.id
  tags               = merge (
                    {"Name" ="rumiantsau-environment-alb"}, local.tags
                          )
}

resource "aws_lb_listener" "rumiantsau_environment_alb_listener" {
  load_balancer_arn = aws_lb.rumiantsau_environment_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rumiantsau_environment_alb_target_group.arn

  }
}

resource "aws_lb_target_group" "rumiantsau_environment_alb_target_group" {
  name     = "rumiantsau-env-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.rumiantsau_environment_vpc.id
  # tags                    = merge(var.common_tags, map(
  #                             "Name", "rumiantsau-environment-alb-target-sonarqube"
  #                         ))
}

resource "aws_lb_target_group_attachment" "rumiantsau_environment_alb_target_group_attachment" {
  count = 2
  target_group_arn = aws_lb_target_group.rumiantsau_environment_alb_target_group.arn
  target_id        = element(aws_instance.rumiantsau_environment_empty_instance.*.id, count.index)
  port             = 80
}