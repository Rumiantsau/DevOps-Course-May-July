## EXAM Task

### Result
Link to go the repo Python-add
(https://github.com/Rumiantsau/rumiantsau-python)
* build image "docker build -t rumiantsau-ecs-python ."
* run container "docker run -d -p 8181:8181 --name rumiantsau-ecs-python rumiantsau-ecs-python:latest"
Running application (http://rumiantsau-alb-python-1686930194.us-east-1.elb.amazonaws.com:8181)

Link to go the repo Golang-app
(https://github.com/Rumiantsau/rumiantsau-go)
* build image "docker build -t rumiantsau-ecs-go . "
* run container "docker run -d -p 8080:8080 --name rumiantsau-ecs-go rumiantsau-ecs-go:latest"
Running application (http://rumiantsau-alb-go-603821001.us-east-1.elb.amazonaws.com:8080)