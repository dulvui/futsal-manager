extends Node

var messages = []

enum MESSAGE_TYPES {TRANSFER,TRANSFER_OFFER,CONTRACT_SIGNED,CONTRACT_OFFER,CONTRACT_OFFER_MADE,NEXT_MATCH}

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

func message(content,type):
	print("new " + str(type) + " mail")
	match type:
		MESSAGE_TYPES.TRANSFER:
			print("TRANSFER")
			var ts_message
			if content.has("success"):
				if content["success"]:
					ts_message = {
						"title" : "TRANSFER",
						"message" : "You bought for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"],
						"days" : 7,
						"type" : type,
						"read" : false
					}
				else:
					ts_message = {
						"title" : "TRANSFER",
						"message" : "You couldnt buy for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"],
						"days" : 7,
						"type" : type,
						"read" : false
					}
			else:
				ts_message = {
				"title" : "TRANSFER",
				"message" : "You made an " + str(content["money"]) + " offer for " + content["player"]["name"] + " " + content["player"]["surname"],
				"days" : 7,
				"type" : type,
				"read" : false
			}
			messages.append(ts_message)
		# contract
		MESSAGE_TYPES.CONTRACT_OFFER:
			var ts_message = {
				"title" : "CONTRACT",
				"message" : "You need to make an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"],
				"days" : 7,
				"type" : type,
				"read" : false,
				"content" : content
			}
			messages.append(ts_message)
		MESSAGE_TYPES.CONTRACT_OFFER_MADE:
			var ts_message = {
				"title" : "CONTRACT",
				"message" : "You made an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"],
				"days" : 7,
				"type" : type,
				"read" : false,
				"content" : content
			}
			messages.append(ts_message)
		MESSAGE_TYPES.CONTRACT_SIGNED:
			var ts_message = {
				"title" : "new player",
				"message" : "The player acceptet " + content["player"]["name"] + " " + content["player"]["surname"] + " the contract",
				"days" : 7,
				"type" : type,
				"read" : false,
				"content" : content
			}
			messages.append(ts_message)
			
		MESSAGE_TYPES.NEXT_MATCH:
			var message = {
				"title" : "next match",
				"message" : "The next match is " + str(content),
				"days" : 7,
				"type" : type,
				"read" : false,
				"content" : content
			}
			messages.append(message)
	
	

