## Task#5: Build a docker container for your python app. Deadline - 28/06/2021

### Result
* build image "docker build -t python_app ."
* run container "docker run -d -p 8080:8080 --name python_app python_app:latest"

### Task definition:
- package your Python application into a minimal size docker container;
- write a README.md explaining how to create and run a container.

### Requirements:
* the result of the assembly must be an image not exceeding 100MB
* application must listen on port 8080
* request `curl -d '{" animal ":" cow "," sound ":" moooo "," count ": 3}' http://localhost:8080/` should return the expected response
* the directory with the task should contain only the files required for the build and README.md
* only `docker build` and / or` docker-compose` are allowed

### Hints:
- think carefully about what you really need to run the application and what you can do without
- searching for `docker image staged build` may help you
- as an option, you can put a bash script next to it for automatic build, launch, check the application

### Links
* [Julia Evans blog](https://jvns.ca/)
* [Julia Evans wizardzines](https://wizardzines.com/)
* [Jessie Frazelle blog/links to talks](https://blog.jessfraz.com/post/talks/#2018)
* [Jessie Frazelle dockerfiles repo](https://github.com/jessfraz/dockerfiles)
* [random guys, bocker project](https://github.com/p8952/bocker)

