### --- === EC2 instances === --- ###

data "aws_ami" "nat_instance" {
  most_recent = true
  filter {
    name                  = "virtualization-type"
    values                = ["hvm"]
  }
  filter {
    name                  = "name"
    values                = ["amzn-ami-vpc-nat-hvm*"]
  }
  owners                  = ["amazon"]
}

data "aws_ami" "env_instance" {
  most_recent = true
  filter {
    name                  = "virtualization-type"
    values                = ["hvm"]
  }
  filter {
    name                  = "name"
    values                = ["amzn2-ami-hvm-2*"]
  }
  owners                  = ["amazon"] 
}

resource "aws_key_pair" "rumiantsau_environment_key_pair" {
  key_name                    = "rumiantsau-environment-key-pair"
  public_key                  = var.ssh_key
                      tags               = merge (
                    {"Name" = "rumiantsau-environment-nat-instance"}, local.tags
                          ) 
}

### --- === NAT instances === --- ###

resource "aws_instance" "rumiantsau_environment_nat_instance" {
  ami                         = data.aws_ami.nat_instance.id
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.rumiantsau_environment_public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.rumiantsau_environment_web_access.id, aws_security_group.rumiantsau_environment_internal_ssh_access.id]
  key_name                    = aws_key_pair.rumiantsau_environment_key_pair.id
  depends_on                  = [aws_security_group.rumiantsau_environment_external_ssh_access]
  source_dest_check           = "false"
          tags               = merge (
                    {"Name" = "rumiantsau-environment-nat-instance"}, local.tags
                          ) 
}

### --- === BASTION instances === --- ###

resource "aws_instance" "rumiantsau_environment_bastion_instance" {
  ami                         = data.aws_ami.env_instance.id
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.rumiantsau_environment_public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.rumiantsau_environment_external_ssh_access.id]
  key_name                    = aws_key_pair.rumiantsau_environment_key_pair.id
  lifecycle {
    prevent_destroy           = "true"
  }
  depends_on                  = [aws_security_group.rumiantsau_environment_external_ssh_access]
  tags               = merge (
                    {"Name" = "rumiantsau-environment-bastion-instance"}, local.tags
                          ) 
}

### --- === empty instances === --- ###

resource "aws_instance" "rumiantsau_environment_empty_instance" {
  count                       = 2
  ami                         = data.aws_ami.env_instance.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.rumiantsau_environment_private_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.rumiantsau_environment_internal_ssh_access.id, aws_security_group.rumiantsau_environment_web_access.id]
  key_name                    = aws_key_pair.rumiantsau_environment_key_pair.id
  iam_instance_profile        = aws_iam_instance_profile.access_ec2_to_s3.name
  user_data                   = data.template_file.script.rendered
  tags               = merge (
                    {"Name" = "rumiantsau-environment-instance-${count.index+1}"}, local.tags
                          ) 
}

data template_file script {
  template                    = file("script.yaml")
}