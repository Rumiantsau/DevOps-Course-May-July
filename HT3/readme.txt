### Readme.txt

## To use the bot, follow the link
# http://t.me/RumiantsauBot  

Instruction for your own implementation.

1. First, we need to register our future bot in Telegram. This is done as follows:

- You need to install the Telegram app on your phone or computer. You can download the application;
- Add a bot named BotFather to our contact list
- We start the procedure of "communication" with the bot by pressing the Start button. 
- In order to create a new bot, you need to run the command / newbot and follow the instructions. 
Please note that the username for a bot must always contain the word bot at the end. For example, DjangoBot or Django_bot.

2. Clone this repository. Check all requiret modules are installed. If not, install them:

go get github.com/Syfaro/telegram-bot-api

3. Compile app with next command:

go build app.go

4. Edit config.json with your github user, github repo and Telegram bot Token.
{
    "Name": "username",
    "Reponame": "repository_name",
    "Token":"telegram_token"
}

5. Run tgbot and enjoy!

go run app.go

Usage

This bot implements 5 commands:
 - /start  - welcom message and implemented commands;
 - /help   - implemented commands;
 - /git    - returns the address of your repository;
 - /tasks  - returns a numbered list of your completed tasks;
 - /task # - where '#' is the task number, returns a link to the folder in your repository with the completed task.