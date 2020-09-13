extends Node

var messages = []

func _ready():
	messages = DataSaver.messages


# make update method connected to new day signal of calendar
func update():
	for message in messages:
		message["days"] -= 1
		if message["days"] < 1 and message["read"]:
			messages.erase(message)
			
func count_unread_messages():
	var counter = 0
	for message in messages:
		if not message["read"]:
			counter += 1
	return counter

func message(new_message):
	print("new mail")
	if new_message[1] == "TRANSFER":
		print("TRANSFER")
		var ts_message
		if new_message[0].has("success"):
			if new_message[0]["success"]:
				ts_message = {
					"title" : "TRANSFER",
					"message" : "You bought for" + str(new_message[0]["money"]) + " " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
					"days" : 7,
					"type" : "TRANSFER",
					"read" : false
				}
			else:
				ts_message = {
					"title" : "TRANSFER",
					"message" : "You couldnt buy for" + str(new_message[0]["money"]) + " " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
					"days" : 7,
					"type" : "TRANSFER",
					"read" : false
				}
		else:
			ts_message = {
			"title" : "TRANSFER",
			"message" : "You made an " + str(new_message[0]["money"]) + " offer for " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
			"days" : 7,
			"type" : "TRANSFER",
			"read" : false
		}
		messages.append(ts_message)
	# contract
	else:
		var ts_message = {
			"title" : "CONTRACT",
			"message" : "You need to make an contract offer for " + new_message[0]["player"]["name"] + " " + new_message[0]["player"]["surname"],
			"days" : 7,
			"type" : new_message[1],
			"read" : false,
			"content" : new_message[0]
		}
		messages.append(ts_message)
	
	

