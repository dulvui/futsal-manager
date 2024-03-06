# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal refresh_inbox

# const MAX_MESSAGES:int = 50

func latest() -> EmailMessage:
	if Config.inbox.list.size() == 0:
		return null
	return Config.inbox.list[-1]

func count_unread_messages() -> int:
	var counter:int = 0
	for message:EmailMessage in Config.inbox.list:
		if not message["read"]:
			counter += 1
	return counter
	
func _add_message(message:EmailMessage) -> void:
	Config.inbox.list.append(message)
	# if Config.inbox.list.size() > MAX_MESSAGES:
	# 	Config.inbox.list.pop_front()
	refresh_inbox.emit()

func new_message(type:int) -> void:
	print("new " + str(type) + " mail")
	var message:EmailMessage = EmailMessage.new()
	_add_message(message)

func next_match(p_match:Match) -> void:
	var team_name:String = p_match.home.name
	if team_name == Config.team.name:
		team_name = p_match.away.name

	
	var message:EmailMessage = EmailMessage.new()
	message.subject = tr("NEXT_MATCH") + " against " + team_name
	message.text = "The next match is against " + team_name + ".\nThe quotes are: "
	message.sender = "info@" + Config.team.name.to_lower() + ".com"
	message.date = Config.calendar().format_date()
	_add_message(message)


func transfer_message(transfer:Transfer) -> void:
	var message:EmailMessage = EmailMessage.new()
	message.date = Config.calendar().format_date()

	# assign rid of transfer, so it can be used for toher purposes
	message.resource_rid = transfer.get_rid()
	
	if transfer.buy_team.name == Config.team.name:
		message.sender = "info@" + transfer.sell_team.name.to_lower() + ".com"
	else:
		message.sender = "info@" + transfer.buy_team.name.to_lower() + ".com"
	
	match transfer.state:
		Transfer.State.OFFER:
			message.subject = "OFFER: " + transfer.player.get_full_name()
			message.text = "You made an " + str(transfer.price) + " offer for " + transfer.player.get_full_name()
		Transfer.State.SUCCESS:
			message.subject = "TRANSFER SUCCESS: " + transfer.player.get_full_name()
			message.text = "You bought for" + str(transfer.price) + " " + transfer.player.get_full_name()
		Transfer.State.OFFER_DECLINED:
			message.subject = "OFFER_DECLINED"
			message.text = "The team " + transfer.sell_team.name + " definitly declined your offer for " + transfer.player.get_full_name()
		Transfer.State.CONTRACT:
			message.subject = "OFFER_ACCEPTED"
			message.text = "The team " + transfer.sell_team.name + " agreed to your offer for " + transfer.player.get_full_name()
			message.text += "\nNow you need to find an agreement with the player. Offer him a contract."
			message.type = EmailMessage.Type.CONTRACT_OFFER
		Transfer.State.CONTRACT_PENDING:
			message.subject = "CONTRACT OFFER MADE"
			message.text = "You made an contract offer for " + transfer.player.get_full_name()
			message.text = "The income is " + str(transfer.contract.income)
		Transfer.State.SUCCESS:
			message.subject = "CONTRACT_SIGNED"
			message.text = "The player " + transfer.player.get_full_name() + " acceptet the contract"
		Transfer.State.CONTRACT_DECLINED:
			message.subject = "CONTRACT_DECLINED"
			message.text = "The player " + transfer.player.get_full_name() + " acceptet the contract"
		_:
			message.subject = "ERROR"
			message.text = "Error in code " + transfer.player.get_full_name()


	_add_message(message)

		
func welcome_manager() -> void:
	var message:EmailMessage = EmailMessage.new()
	message.subject = tr("WELCOME")
	message.text = "The team " + Config.team.name + " welcomes you as the new Manager!"
	message.sender = "info@" + Config.team.name.to_lower() + ".com"
	message.date = Config.calendar().format_date()
	_add_message(message)


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
