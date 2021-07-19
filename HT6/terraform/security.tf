### --- === Security groups === --- ###

resource "aws_security_group" "rumiantsau_environment_external_ssh_access" {
  name          = "ssh-access-from-minsk"
  description   = "Allow SSH traffic"
  vpc_id        = aws_vpc.rumiantsau_environment_vpc.id

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
              tags               = merge (
                    {"Name" = "rumiantsau-environment-external-ssh-access"}, local.tags
                          ) 
}

resource "aws_security_group" "rumiantsau_environment_internal_ssh_access" {
  name          = "ssh-access"
  description   = "Allow SSH traffic"
  vpc_id        = aws_vpc.rumiantsau_environment_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.rumiantsau_environment_vpc.cidr_block]
  }
  egress {
    from_port   = 0 #Allow all traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
              tags               = merge (
                    {"Name" = "rumiantsau-environment-internal-ssh-access"}, local.tags
                          ) 
}

resource "aws_security_group" "rumiantsau_environment_web_access" {
  name          = "rumiantsau-environment-web-access"
  description   = "Allow web traffic"
  vpc_id        = aws_vpc.rumiantsau_environment_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
                tags               = merge (
                    {"Name" = "rumiantsau-environment-web-access"}, local.tags
                          ) 
}