extends Node

var messages = []

func _ready():
	messages = DataSaver.messages


# make update method connected to new day signal of calendar
func update():
	for message in messages:
		message["days"] -= 1
		if message["days"] < 1:
			messages.erase(message)

func message(new_message):
	print("new mail")
	if new_message[1] == "TRANSFER":
		print("TRANSFER")
		var ts_message
		if new_message[0].has("success"):
			if new_message[0]["success"]:
				ts_message = {
					"title" : "TRANSFER",
					"message" : "You bought for" + new_message[0]["money"] + " " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
					"days" : 7,
					"type" : "TRANSFER",
					"read" : false
				}
			else:
				ts_message = {
					"title" : "TRANSFER",
					"message" : "You couldnt buy for" + new_message[0]["money"] + " " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
					"days" : 7,
					"type" : "TRANSFER",
					"read" : false
				}
		else:
			ts_message = {
			"title" : "TRANSFER",
			"message" : "You made an " + new_message[0]["money"] + " offer for " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
			"days" : 7,
			"type" : "TRANSFER",
			"read" : false
		}
		messages.append(ts_message)
	
	

