# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal transfer_mail

var current_transfers = []

func _ready() -> void:
	current_transfers = Config.current_transfers

func update_day() -> void:
	#check with calendar if treansfer market is open, then send start/stop mail
	if CalendarUtil.is_market_active():
		_request_players()

		# do transfers
		for transfer in current_transfers:
			if "PENDING" in transfer["state"]:
				transfer["days"] -= 1
				if transfer["days"] < 1:
					if transfer["state"] == "TEAM_PENDING":
#						transfer["success"] = randi()%2 == 0
						transfer["success"] = true
						transfer["days"] = (randi()%5)+1
						transfer["state"] = "MAKE_CONTRACT_OFFER"
						EmailUtil.new_message(EmailUtil.MessageTypes.CONTRACT_OFFER, transfer)
					elif transfer["state"] == "CONTRACT_PENDING":
						transfer["success"] = randi()%2 == 0
		#				if transfer["success"]:
						transfer["state"] = "SUCCESS"
						Config.make_transfer(transfer)
						EmailUtil.new_message(EmailUtil.MessageTypes.CONTRACT_SIGNED, transfer)
		


func make_offer(transfer:Dictionary) -> void:
	EmailUtil.new_message(EmailUtil.MessageTypes.TRANSFER, transfer)
	print("transfer message")
	current_transfers.append(transfer)
	

static func _request_players() -> void:
	if randi_range(1, Constants.REQUEST_FACTOR) == Constants.REQUEST_FACTOR:
		# pick random team, that needs a player
		# depending on presitge of team, buy cheap or expensive player
		# loans also possible
		# once market offer made, request preocess starts
		# decline, accept, counter offer
		# if accepted, player needs to aggre
		# can affect players mood, if he wants to leave and you don't let him go
		# or viceversa, then he would start with bad mood at other team
		# make sure no duplicate offers are made, and once a player is sold
		# he can't be sold twice and no offers for sold playersg
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_OFFER)
