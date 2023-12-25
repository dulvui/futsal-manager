# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var messages:Array = []

const MAX_MESSAGES:int = 30

func _ready() -> void:
	messages = Config.messages
	
func latest() -> EmailMessage:
	if messages.size() == 0:
		return null
	return messages[-1]

func count_unread_messages() -> int:
	var counter:int = 0
	for message:EmailMessage in messages:
		if not message["read"]:
			counter += 1
	return counter

func new_message(type:int, content:Dictionary = {}) -> void:
	print("new " + str(type) + " mail")
	var message:EmailMessage = EmailMessage.new()
	messages.append(message)
	
	if messages.size() > MAX_MESSAGES:
		messages.pop_front()

func next_match(next_match:Dictionary) -> void:
	var team_name:String = next_match["home"]
	if team_name == Config.team.name:
		team_name = next_match["away"]
	
	var message:EmailMessage = EmailMessage.new()
	message.subject = tr("NEXT_MATCH") + " against " + team_name
	message.text = "The next match is against " + team_name + ".\nThe quotes are: "
	messages.append(message)


func new_transfer(transfer:Transfer) -> void:
	print("new transfer mail")
	var message:EmailMessage = EmailMessage.new()
	messages.append(message)
	
	if messages.size() > MAX_MESSAGES:
		messages.pop_front()
		
func welcome_manager() -> void:
	var message:EmailMessage = EmailMessage.new()
	message.subject = tr("WELCOME")
	message.text = "The team " + Config.team.name + " welcomes you as the new Manager!"
	message.sender = "info@" + Config.team.name.to_lower() + ".com"
	message.date = CalendarUtil.get_dashborad_date()
	messages.append(message)

	#match type:
		#Type.TRANSFER:
			#title = "TRANSFER"
			#if content.has("success"):
				#if content["success"]:
					#message["message"] = "You bought for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"]
				#else:
					#message["message"] = "You couldnt buy for" + str(content["money"]) + " " + content["player"]["name"] + " " + content["player"]["surname"]
			#else:
				#message["message"] = "You made an " + str(content["money"]) + " offer for " + content["player"]["name"] + " " + content["player"]["surname"]
		## contract
		#Type.CONTRACT_OFFER:
			#message["message"] = "You need to make an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"]
			#message["title"] = "CONTRACT OFFER"
			#message["content"] = content
		#Type.CONTRACT_OFFER_MADE:
			#message["message"] = "You made an contract offer for " + content["player"]["name"] + " " + content["player"]["surname"]
			#message["title"] = "CONTRACT OFFER MADE"
		#Type.CONTRACT_SIGNED:
			#message["message"] = "The player acceptet " + content["player"]["name"] + " " + content["player"]["surname"] + " the contract"
			#message["title"] = "CONTRACT_SIGNED"
		#Type.NEXT_MATCH:
			#var team_name:String = content["home"]
			#if team_name == Config.team.name:
				#team_name = content["away"]
			#message["message"] = "The next match is against " + team_name + ".\nThe quotes are: "
			#message["title"] = tr("NEXT_MATCH") + " against " + team_name
		#Type.WELCOME_MANAGER:
			#message["message"] = "The team " + Config.team.name + " welcomes you as the new Manager!"
			#message["title"] = tr("WELCOME")
		#Type.NEXT_SEASON:
			#message["message"] = "The new season begins."
			#message["title"] = "SEASON " + str(Config.date.year) + " STARTS"
		#Type.MARKET_START:
			#message["message"] = "The market begins today."
			#message["title"] = "MARKET STARTS"
		#Type.MARKET_END:
			#message["message"] = "The market ends today."
			#message["title"] = "MARKET ENDS"
		#Type.MARKET_OFFER:
			#message["message"] = "Another team is interested in your player"
			#message["title"] = "MARKET OFFER"

func transfer_message(transfer:Transfer) -> void:
	print("new transfer mail")
	
	var message:EmailMessage = EmailMessage.new()

	message["title"] = "TRANSFER"
	if transfer.state == Transfer.State.SUCCESS:
		message["message"] = "You bought for" + str(transfer.price) + " " + transfer.player.get_full_name()
	elif transfer.state == Transfer.State.OFFER:
		message["message"] = "You couldnt buy for" + str(transfer.price) + " " + transfer.player.get_full_name()
	else:
		message["message"] = "You made an " + str(transfer.price) + " offer for " + transfer.player.get_full_name()


