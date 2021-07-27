### --- === VPC === --- ###

data "aws_availability_zones" "available_zones_in_current_region" {
  state                   = "available"
}

resource "aws_vpc" "rumiantsau_vpc" {
  cidr_block              = var.vpc_network
  enable_dns_hostnames    = true
  tags                    = merge ({"Name" = "rumiantsau-vpc"}, local.tags)
}

resource "aws_subnet" "rumiantsau_public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.rumiantsau_vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available_zones_in_current_region.names[count.index]
  map_public_ip_on_launch = "true"
  tags = merge ({"Name" = "rumiantsau-public-subnets-${count.index+1}"}, local.tags)
}

### --- === Internet gateway === --- ###

resource "aws_internet_gateway" "rumiantsau_igw" {
  vpc_id = aws_vpc.rumiantsau_vpc.id
  tags = merge ({"Name" = "rumiantsau-igw"}, local.tags)
}

### --- === Route tables === --- ###

resource "aws_route_table" "rumiantsau_vpc_public_route_table" {
  vpc_id = aws_vpc.rumiantsau_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rumiantsau_igw.id
  }
    tags = merge ({"Name" = "rumiantsau-vpc-public-route-table"}, local.tags)
}

### --- === Route tables association === --- ###

resource "aws_route_table_association" "associate_public_subnets_with_public_route_table1" {
  subnet_id               = aws_subnet.rumiantsau_public_subnets[0].id
  route_table_id          = aws_route_table.rumiantsau_vpc_public_route_table.id
}

resource "aws_route_table_association" "associate_public_subnets_with_public_route_table2" {
  subnet_id               = aws_subnet.rumiantsau_public_subnets[1].id
  route_table_id          = aws_route_table.rumiantsau_vpc_public_route_table.id
}