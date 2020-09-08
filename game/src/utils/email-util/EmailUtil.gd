extends Node

var messages = []

func _ready():
	messages = DataSaver.messages
	
	var ts_message = {
		"title" : "TRANSFER",
		"message" : "You made an",
		"days" : 7,
		"type" : "TRANSFER",
		"read" : false
	}
	messages.append(ts_message)


# make update method connected to new day signal of calendar
func update():
	for message in messages:
		message["days"] -= 1
		if message["days"] < 1:
			messages.erase(message)

func message(new_message,type):
	print("new mail with message " + new_message)
	if type == "TRANSFER":
		var ts_message = {
			"title" : "TRANSFER",
			"message" : "You made an " + new_message["money"] + " offer for " + new_message["player"]["name"] + " " + new_message["player"]["surname"],
			"days" : 7,
			"type" : "TRANSFER",
			"read" : false
		}
		messages.append(ts_message)
	
	

