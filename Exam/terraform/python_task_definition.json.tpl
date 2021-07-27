[
  {
    "name": "rumiantsau-ecs-python",  
    "image": "${REPOSITORY_URL}:master-latest",  
    "cpu": 512,
    "memory": 512,
    "portMappings": [
       {
         "containerPort": 8181,
         "hostPort": 8181,
         "protocol": "tcp"
       }
     ],
     "essential": true,
     "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "ecs/rumiantsau-python",
            "awslogs-region": "us-east-1"
            }
     }     
  }
]