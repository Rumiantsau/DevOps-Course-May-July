#!/bin/bash
echo ====================================================
echo "--This is script for interaction with github API--"
echo ====================================================
read -p "Enter the github URL (an url like "'https://github.com/$user/$repo'"): " inputURL

SUB="https://github.com/"

if [[ "$inputURL" != *"https://github.com/"* ]]; then
echo ====================================================
echo "-------------Incorrect input format.--------------"
echo ====================================================

  exit 1
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

function pullrequestWithLabel {
  echo "Print the number of PRs each contributor has created with the labels"
  curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${inputURL}/pulls | jq '.[] | .label'
}

function custom_func {
  echo "This function will show U all public repositories of user"
  username=${input_data%/*}
  echo $username
  curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/users/${username}/repos | jq -r '.[] | .name'
}

one="Checks if there are open pull requests"
two="Print the list of the most productive contributors (authors of more than 1 open PR)"
tree="Print the number of PRs each contributor has created with the labels"
four="My own feature ()"
five="Ask your chat mate to review your code and create a meaningful pull request"

PS3="Select the required action: "
select opt in "$one" "$two" "$tree" "$four" "$five" Quit; do
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

      ;;
    $five)

      ;;
    Quit)
      break
      ;;
    *)
      echo "Недопустимая опция $REPLY"
      ;;
  esac
done