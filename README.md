# DevOps-Course-May-July
Andersen DevOps Course Summer 2021 by [Andersenlab](https://www.andersenlab.com/)

## Task#1: Create and deploy your own service 
### Task definition:
We will need Python3, Flask and emoji support.
### Result
curl -XPOST -d'{"animal":"cow", "sound":"moooo", "count": 3}' http://myvm.localhost/
cow says moooo
cow says moooo
cow says moooo
Made with ❤️ by %your_name

## Task#2: Сonvert one liner to nice script
### Task definition:
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

## Task#3: Write a functioning telegram bot in GO language with at least 3 commands:
### Task definition:
Executable commands
- 'Git' - returns a numbered list of your completed tasks.
- 'Tasks' - returns a numbered list of your completed tasks.
- 'Task#' where '#' is the task number, returns a link to the folder in your repository with the completed task. 

## Task#4: Unleash your creativity with GitHub
### Task definition:
- write a script that checks if there are open pull requests for a repository. An url like "https://github.com/$user/$repo" will be passed to the script
- print the list of the most productive contributors (authors of more than 1 open PR)
- print the number of PRs each contributor has created with the labels
- implement your own feature that you find the most attractive: anything from sorting to comment count or even fancy output format
- ask your chat mate to review your code and create a meaningful pull request
- do the same for her xD
- merge your fellow PR! We will see the repo history