#!/bin/bash
echo ====================================================
echo "--This is script for interaction with github API--"
echo ====================================================
read -p "Enter the github URL (an url like "'https://github.com/$user/$repo'"): " inputURL

# Validation of entered URL
re='https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'
if ! [[ $inputURL =~ $re ]] ; then
echo ====================================================
echo "--------------Incorrect input format--------------"; exit 1
echo ====================================================
fi

echo "$inputURL"

inputURL=${inputURL#https://github.com/}

function empty_input {
if [ -z $inputURL ]
  then
        echo ====================================================
        echo "-------------error: Empty input URL---------------"
        echo ====================================================
    exit 1
fi
}

empty_input

echo "URL fo work:     $inputURL"

#empty_input

function openPullRequest {
  echo "Open pull requests for a repository"
  curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${inputURL}/pulls  #Default: state=open
}

function mostContributors {
  echo "The list of the most productive contributors (authors of more than 1 open PR)"
  curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${inputURL}/pulls?state=open | jq '.[].user.login' | sort | uniq -cd
}

#allUsersLogins=()
#allUsersLinks=()

function pullrequestWithLabel {
  echo "Print the number of PRs each contributor has created with the labels"
  echo "-----------------------------------"
  allUsersLogins=($(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${inputURL}/pulls | jq '.[].user.login'))
  allUsersLinks=($(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${inputURL}/pulls | jq '.[] | .labels | length'))
  echo
  for((i=0; i<${#allUsersLogins[@]};i++));
  do
    echo "${allUsersLogins[i]} - ${allUsersLinks[i]}"
  done
}

function myFunc {
  echo "This function will show U all public repositories of user"
  read -p "Write username for search: " username
  curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/users/${username}/repos | jq -r '.[]'
}

one="Checks if there are open pull requests"
two="Print the list of the most productive contributors (authors of more than 1 open PR)"
tree="Print the number of PRs each contributor has created with the labels"
four="My own feature ()"
five="Ask your chat mate to review your code and create a meaningful pull request"

PS3="Select the required action. 1 - $one. 2 - $two. 3 - $tree. 4 - $four. 5 - Quit : "
select opt in "$one" "$two" "$tree" "$four" Quit; do
  case $opt in
    $one)
      openPullRequest
      ;;
    $two)
      mostContributors
      ;;
    $tree)
     pullrequestWithLabel
      ;;
    $four)
     myFunc
      ;;
    Quit)
      break
      ;;
    *)
      echo "Incorrect input $REPLY"
      ;;
  esac
done