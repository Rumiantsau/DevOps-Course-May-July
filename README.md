# DevOps-Course-May-July
Andersen DevOps Course Summer 2021 by [Andersenlab](https://www.andersenlab.com/)

## Task#1: Create and deploy your own service. Deadline - 23/06/2021 
### Task definition:
We will need Python3, Flask and emoji support.
### Result
curl -XPOST -d'{"animal":"cow", "sound":"moooo", "count": 3}' http://myvm.localhost/  
cow says moooo  
cow says moooo  
cow says moooo  
Made with ❤️ by %your_name

## Task#2: Сonvert one liner to nice script. Deadline - 14/06/2021
### Task definition:
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

## Task#3: Write a functioning telegram bot in GO language with at least 3 commands. Deadline - 30/06/2021
### Task definition:
Executable commands
- 'Git' - returns a numbered list of your completed tasks.
- 'Tasks' - returns a numbered list of your completed tasks.
- 'Task#' where '#' is the task number, returns a link to the folder in your repository with the completed task. 

## Task#4: Unleash your creativity with GitHub. Deadline - 21/06/2021
### Task definition:
- write a script that checks if there are open pull requests for a repository. An url like "https://github.com/$user/$repo" will be passed to the script
- print the list of the most productive contributors (authors of more than 1 open PR)
- print the number of PRs each contributor has created with the labels
- implement your own feature that you find the most attractive: anything from sorting to comment count or even fancy output format
- ask your chat mate to review your code and create a meaningful pull request
- do the same for her xD
- merge your fellow PR! We will see the repo history

## Task#5: Build a docker container for your python app. Deadline - 28/06/2021
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

## Task#6: Optional homework (AWS). Deadline - 20/07/2021

