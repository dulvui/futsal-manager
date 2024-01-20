# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal transfer_mail

func update_day() -> void:
	#check with calendar if treansfer market is open, then send start/stop mail
	if CalendarUtil.is_market_active():
		_request_players()

		# do transfers
		for transfer in Config.current_transfers:
			if transfer.update():
				# TODO once other teams can make trades between themselfes, only send email
				# for transfers affectiing own team
				# otehrwhise send a news id if important, or simply add to market history
				EmailUtil.transfer_message(transfer)
	else:
		print("TODO cancel all remaining transfers and send market clossed email")

func make_offer(transfer:Transfer) -> void:
	EmailUtil.transfer_message(transfer)
	Config.current_transfers.append(transfer)
	

func _request_players() -> void:
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
		#EmailUtil.transfer_message()
		print("TODO create random player requests")
