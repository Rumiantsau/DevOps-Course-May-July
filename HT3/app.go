package main
import (

  tgbotapi "github.com/Syfaro/telegram-bot-api"
  "log"
  "os"
  "fmt"
  "encoding/json"
  "io/ioutil"
  "net/http"
  "strconv"
)

type Config struct {
	Name     string
	Reponame string
	Token    string
}

func getargs() Config {
	file, _ := os.Open("config.json")
	defer file.Close()
	decoder := json.NewDecoder(file)
	config := Config{}
	err := decoder.Decode(&config)
	if err != nil {
		fmt.Println("error:", err)
	}
	return (config)
}

func getTasks(conf Config) []string {
	taskTree := fmt.Sprintf("https://api.github.com/repos/%s/%s/git/trees/main", conf.Name, conf.Reponame)
	resp, err := http.Get(taskTree)
	if err != nil {
		log.Fatalln(err)
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	sb := string(body)
	var result map[string][]interface{}
	var resq []string
	json.Unmarshal([]byte(sb), &result)
	for _, v := range result["tree"] {
		entry := v.(map[string]interface{})
		if entry["type"] == "tree" {
			resq = append(resq, fmt.Sprintf("%v", entry["path"]))
		}
	}
	return resq
}

func main() {
conf := getargs()
	bot, err := tgbotapi.NewBotAPI(conf.Token)
	if err != nil {
		log.Panic(err)
	}

	bot.Debug = false

	log.Printf("Authorized on account %s", bot.Self.UserName)

	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60

	updates, err := bot.GetUpdatesChan(u)

	for update := range updates {
		if update.Message == nil { // ignore any non-Message Updates
			continue
		}

		if update.Message.IsCommand() {
			command := update.Message.Command()
			switch command {
			case "start":
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "")
			msg.Text = "This is the telegram-bot of Mikalay Rumyantsev's DevOps training repository.\n" +
			    "This bot implements 5 commands\n" +
				"'/start' - welcom message and implemented commands\n'"+
				"'/help' - implemented commands\n" +
				"'/git' - returns the address of your repository.\n" +
				"'/tasks' - returns a numbered list of your completed tasks\n" +
				"'/task #' where '#' is the task number, returns a link to the folder in your repository with the completed task\n"
				bot.Send(msg)
			case "help":
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "")
			msg.Text = "Selected command '/help'\n" +
				"'/start' - Information message about this -bot-\n'"+
				"'/git' - Returns the address of your repository.\n" +
				"'/tasks' - Returns a numbered list of your completed tasks\n" +
				"'/task #' - Returns a link to the folder in your repository with the completed task, where '#' is the task number\n"
				bot.Send(msg)	
			case "git":
				repoUrl := fmt.Sprintf("https://github.com/%s/%s", conf.Name, conf.Reponame)
				msg := tgbotapi.NewMessage(update.Message.Chat.ID, repoUrl)
				bot.Send(msg)
			case "tasks":
				var rString string = ""
				tasks := getTasks(conf)
				for i, t := range tasks {
					task := fmt.Sprintf("%d - %s ", i+1, t)
					rString = rString + task + "\n"
				}
				msg := tgbotapi.NewMessage(update.Message.Chat.ID, rString)
				bot.Send(msg)
			case "task":
				taskArgs := update.Message.CommandArguments()
				tasks := getTasks(conf)
				inputNum, err := strconv.Atoi(taskArgs)
				if err != nil {
					// handle error
					msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Got error task number: "+taskArgs)
					bot.Send(msg)
				}
				if inputNum > 0 {
					taskUrl := fmt.Sprintf("https://github.com/%s/%s/tree/main/%s", conf.Name, conf.Reponame, tasks[inputNum-1])
					msg := tgbotapi.NewMessage(update.Message.Chat.ID, taskUrl)
					bot.Send(msg)
				} else {
					msg := tgbotapi.NewMessage(update.Message.Chat.ID, "Got error task number: "+taskArgs)
					bot.Send(msg)
				}
			}
		}
	}
}