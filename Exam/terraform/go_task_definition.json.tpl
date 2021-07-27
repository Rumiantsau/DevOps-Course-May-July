[
  {
    "name": "rumiantsau-ecs-go",
    "image": "${REPOSITORY_URL}:master-latest",
    "cpu": 512,
    "memory": 512,
    "essential": true,
    "portMappings": [
       {
         "containerPort": 8080,
         "hostPort": 8080,
         "protocol": "tcp"
       }
     ],
     "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "ecs/rumiantsau-go",
            "awslogs-region": "us-east-1"
            }
     }      
  }
]