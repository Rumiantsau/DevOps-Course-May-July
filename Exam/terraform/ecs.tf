data "template_file" "rumiantsau_python_task_definition_template" {
    template = file("python_task_definition.json.tpl")
    vars = {
      REPOSITORY_URL = replace(aws_ecr_repository.rumiantsau_ecs_python.repository_url, "https://", "")
    }
}

data "template_file" "rumiantsau_go_task_definition_template" {
    template = file("go_task_definition.json.tpl")
    vars = {
      REPOSITORY_URL = replace(aws_ecr_repository.rumiantsau_ecs_go.repository_url, "https://", "")
    }
}

resource "aws_ecs_cluster" "rumiantsau_ecs_cluster" {
  name = "rumiantsau-ecs-cluster"
  tags = merge ({"Name" = "rumiantsau-ecs-cluster"}, local.tags) 
}

resource "aws_ecs_service" "rumiantsau_python_worker" {
  name            = "rumiantsau-python-worker"
  cluster         = aws_ecs_cluster.rumiantsau_ecs_cluster.id
  task_definition = aws_ecs_task_definition.rumiantsau_python_task_definition.arn
  desired_count   = 1
  force_new_deployment = true
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 100
  load_balancer {
    target_group_arn = aws_lb_target_group.rumiantsau_alb_tg_python.arn
    container_name   = "rumiantsau-ecs-python"
    container_port   = 8181
  }
}

resource "aws_ecs_service" "rumiantsau_go_worker" {
  name            = "rumiantsau-go-worker"
  cluster         = aws_ecs_cluster.rumiantsau_ecs_cluster.id
  task_definition = aws_ecs_task_definition.rumiantsau_go_task_definition.arn
  desired_count   = 1
  force_new_deployment = true
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 100
  load_balancer {
    target_group_arn = aws_lb_target_group.rumiantsau_alb_tg_go.arn
    container_name   = "rumiantsau-ecs-go"
    container_port   = 8080
  }
}

resource "aws_ecs_task_definition" "rumiantsau_python_task_definition" {
  family                = "rumiantsau_python_worker"
  container_definitions = data.template_file.rumiantsau_python_task_definition_template.rendered
  execution_role_arn    = aws_iam_role.rumiantsau_ecs_task.arn
  cpu = 512
  memory = 512
}

resource "aws_ecs_task_definition" "rumiantsau_go_task_definition" {
  family                = "rumiantsau_go_worker"
  container_definitions = data.template_file.rumiantsau_go_task_definition_template.rendered
  execution_role_arn    = aws_iam_role.rumiantsau_ecs_task.arn
  cpu = 512
  memory = 512
}

### --- === Autoscaling group === --- ###

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_autoscaling_group" "rumiantsau_ecs_asg" {
    name                      = "rumiantsau-ecs-asg"
    vpc_zone_identifier       = [aws_subnet.rumiantsau_public_subnets[0].id]
    launch_configuration      = aws_launch_configuration.rumiantsau_ecs_launch_config.name
    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 3
    health_check_grace_period = 300
    health_check_type         = "EC2"
    depends_on                = [aws_iam_role.rumiantsau_ecs_agent, aws_lb.rumiantsau_alb_go, aws_lb.rumiantsau_alb_python]
}

resource "aws_iam_role" "rumiantsau_ecs_agent" {
  name               = "rumiantsau-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "rumiantsau_ecs_agent_attachment" {
  role       = aws_iam_role.rumiantsau_ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "rumiantsau_ecs_agent_instance_profile" {
  name = "rumiantsau-ecs-agent"
  role = aws_iam_role.rumiantsau_ecs_agent.name
}

resource "aws_launch_configuration" "rumiantsau_ecs_launch_config" {
    image_id             = data.aws_ami.ecs_optimized.id
    iam_instance_profile = aws_iam_instance_profile.rumiantsau_ecs_agent_instance_profile.name
    security_groups      = [aws_security_group.rumiantsau_web_access.id, aws_security_group.rumiantsau_internal_ssh_access.id, aws_security_group.rumiantsau_icmp_access.id, aws_security_group.rumiantsau_go_access.id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=rumiantsau-ecs-cluster >> /etc/ecs/ecs.config"
    instance_type        = "t3.small"
    key_name             = aws_key_pair.rumiantsau_key_pair.id
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rumiantsau_ecs_task" {
  name               = "rumiantsau-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role_policy_attachment" "rumiantsau_ecs_task_attachment_ecs" {
  role       = aws_iam_role.rumiantsau_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "rumiantsau_ecs_task_attachment_ssm" {
  role       = aws_iam_role.rumiantsau_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_cloudwatch_log_group" "rumiantsau_ecs_python" {
  name        = "ecs/rumiantsau-python"
  tags        = merge ({"Name" = "rumiantsau-ecs-python"}, local.tags) 
}

resource "aws_cloudwatch_log_group" "rumiantsau_ecs_go" {
  name        = "ecs/rumiantsau-go"
  tags        = merge ({"Name" = "rumiantsau-ecs-go"}, local.tags) 
}