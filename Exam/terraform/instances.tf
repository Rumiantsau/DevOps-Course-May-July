# ### --- === EC2 instances === --- ###

data "aws_ami" "ecs_optimized" {
  most_recent = true
  filter {
    name                  = "architecture"
    values                = ["x86_64"]
  }
  filter {
    name                  = "name"
    values                = ["amzn2-ami-ecs-hvm-2*"]
  }
  owners                  = ["amazon"] 
}

resource "aws_key_pair" "rumiantsau_key_pair" {
  key_name                    = "rumiantsau-key-pair"
  public_key                  = var.ssh_key
  tags                        = merge ({"Name" = "rumiantsau-nat-instance"}, local.tags) 
}

