extends Node

var messages = []

const MAX_MESSAGES = 30

enum MESSAGE_TYPES {
					TRANSFER,
					TRANSFER_OFFER,
					CONTRACT_SIGNED,
					CONTRACT_OFFER,
					CONTRACT_OFFER_MADE,
					NEXT_MATCH,
					WELCOME_MANAGER
				}

func _ready():
	messages = DataSaver.messages

func count_unread_messages():
	var counter = 0
	for message in messages:
		if not message["read"]:
			counter += 1
	return counter

func message(content,type):
	print("new " + str(type) + " mail")
	
	var message = {
		"title" : "TRANSFER",
		"message" : "",
		"type" : type,
		"read" : false
	}
	
	match type:
		MESSAGE_TYPES.TRANSFER:
			message["title"] = "TRANSFER"
			if content.has("success"):
				if content["success"]:
					message["message"] = "You bought for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"]
				else:
					message["message"] = "You couldnt buy for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"]
			else:
				message["message"] = "You made an " + str(content["money"]) + " offer for " + content["player"]["name"] + " " + content["player"]["surname"]
		# contract
		MESSAGE_TYPES.CONTRACT_OFFER:
			message["message"] = "You need to make an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"]
			message["title"] = "CONTRACT OFFER"
			message["content"] = content
		MESSAGE_TYPES.CONTRACT_OFFER_MADE:
			message["message"] = "You made an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"]
			message["title"] = "CONTRACT OFFER MADE"
		MESSAGE_TYPES.CONTRACT_SIGNED:
			message["message"] = "The player acceptet " + content["player"]["name"] + " " + content["player"]["surname"] + " the contract"
			message["title"] = "CONTRACT_SIGNED"
		MESSAGE_TYPES.NEXT_MATCH:
			var team_name = content["home"]
			if team_name == DataSaver.selected_team:
				team_name = content["away"]
			message["message"] = "The next match is against " + team_name + ".\nThe quotes are: "
			message["title"] = "NEXT MATCH"
		MESSAGE_TYPES.WELCOME_MANAGER:
			message["message"] = "The team " + DataSaver.selected_team + " welcomes you as the new Manager!"
			message["title"] = "WELCOME MANAGER"
	messages.append(message)
	
	if messages.size() > MAX_MESSAGES:
		messages.pop_front()
	
	

