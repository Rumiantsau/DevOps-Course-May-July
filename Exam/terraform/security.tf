### --- === Security groups === --- ###

resource "aws_security_group" "rumiantsau_external_ssh_access" {
  name          = "ssh-access-from-minsk"
  description   = "Allow SSH traffic"
  vpc_id        = aws_vpc.rumiantsau_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0 #Allow all traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # tags          = merge(var.common_tags, map(
 #                   "Name", "rumiantsau-external-ssh-access"
 #                 ))
}

resource "aws_security_group" "rumiantsau_internal_ssh_access" {
  name          = "ssh-access"
  description   = "Allow SSH traffic"
  vpc_id        = aws_vpc.rumiantsau_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.rumiantsau_vpc.cidr_block]
  }
  egress {
    from_port   = 0 #Allow all traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #tags          = merge(var.common_tags, map(
  #                  "Name", "rumiantsau-internal-ssh-access"
  #                ))
}

resource "aws_security_group" "rumiantsau_web_access" {
  name          = "rumiantsau-web-access"
  description   = "Allow web traffic"
  vpc_id        = aws_vpc.rumiantsau_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #tags          = merge(var.common_tags, map(
  #                  "Name", "rumiantsau-web-access"
  #                ))
}


resource "aws_security_group" "rumiantsau_icmp_access" {
  name          = "rumiantsau-icmp-access"
  description   = "Allow icmp traffic"
  vpc_id        = aws_vpc.rumiantsau_vpc.id

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.rumiantsau_vpc.cidr_block]
  }
  egress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.rumiantsau_vpc.cidr_block]
  }
  #tags          = merge(var.common_tags, map(
  #                  "Name", "rumiantsau-icmp-access"
  #                ))
}

resource "aws_security_group" "rumiantsau_python_access" {
  name          = "rumiantsau-python-access"
  description   = "Allow python traffic"
  vpc_id        = aws_vpc.rumiantsau_vpc.id

  ingress {
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
#  tags          = merge(var.common_tags, map(
#                    "Name", "rumiantsau-python-access"
#                  ))
}

resource "aws_security_group" "rumiantsau_go_access" {
  name          = "rumiantsau-go-access"
  description   = "Allow go traffic"
  vpc_id        = aws_vpc.rumiantsau_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
#  tags          = merge(var.common_tags, map(
#                    "Name", "rumiantsau-go-access"
#                  ))
}