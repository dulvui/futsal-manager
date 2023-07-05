extends Node

var messages:Array = []

const MAX_MESSAGES:int = 30

enum MessageTypes {
					TRANSFER,
					TRANSFER_OFFER,
					CONTRACT_SIGNED,
					CONTRACT_OFFER,
					CONTRACT_OFFER_MADE,
					NEXT_MATCH,
					NEXT_SEASON,
					WELCOME_MANAGER,
					MARKET_START,
					MARKET_END,
					MARKET_OFFER,
				}

func _ready() -> void:
	messages = DataSaver.messages

func count_unread_messages() -> int:
	var counter:int = 0
	for message in messages:
		if not message["read"]:
			counter += 1
	return counter

func new_message(type:int, content:Dictionary = {}) -> void:
	print("new " + str(type) + " mail")
	
	var message:Dictionary = {
		"title" : "TRANSFER",
		"message" : "",
		"sender" : "info@" + DataSaver.team_name.to_lower().replace(" ", "") + ".com",
		"date" : CalendarUtil.get_dashborad_date(),
		"type" : type,
		"read" : false
	}
	
	match type:
		MessageTypes.TRANSFER:
			message["title"] = "TRANSFER"
			if content.has("success"):
				if content["success"]:
					message["message"] = "You bought for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"]
				else:
					message["message"] = "You couldnt buy for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"]
			else:
				message["message"] = "You made an " + str(content["money"]) + " offer for " + content["player"]["name"] + " " + content["player"]["surname"]
		# contract
		MessageTypes.CONTRACT_OFFER:
			message["message"] = "You need to make an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"]
			message["title"] = "CONTRACT OFFER"
			message["content"] = content
		MessageTypes.CONTRACT_OFFER_MADE:
			message["message"] = "You made an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"]
			message["title"] = "CONTRACT OFFER MADE"
		MessageTypes.CONTRACT_SIGNED:
			message["message"] = "The player acceptet " + content["player"]["name"] + " " + content["player"]["surname"] + " the contract"
			message["title"] = "CONTRACT_SIGNED"
		MessageTypes.NEXT_MATCH:
			var team_name = content["home"]
			if team_name == DataSaver.team_name:
				team_name = content["away"]
			message["message"] = "The next match is against " + team_name + ".\nThe quotes are: "
			message["title"] = tr("NEXT_MATCH") + " against " + team_name
		MessageTypes.WELCOME_MANAGER:
			message["message"] = "The team " + DataSaver.team_name + " welcomes you as the new Manager!"
			message["title"] = tr("WELCOME")
		MessageTypes.NEXT_SEASON:
			message["message"] = "The new season begins."
			message["title"] = "SEASON " + str(DataSaver.date.year) + " STARTS"
		MessageTypes.MARKET_START:
			message["message"] = "The market begins today."
			message["title"] = "MARKET STARTS"
		MessageTypes.MARKET_END:
			message["message"] = "The market ends today."
			message["title"] = "MARKET ENDS"
		MessageTypes.MARKET_OFFER:
			message["message"] = "Another temateam is interested in your player"
			message["title"] = "MARKET OFFER"
	messages.append(message)
	
	if messages.size() > MAX_MESSAGES:
		messages.pop_front()
	
	

