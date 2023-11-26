# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name MarketSimulation

static func update():
	_check_players()
	if CalendarUtil.is_market_active():
		_request_players()

# checks if players should be sold
static func _check_players() -> void:
	pass


# finds player that fits team on their needs
# can be used as buy tip of osservatore for your team
static func find_player() -> void:
	pass


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


# move make transfer method from Global to here
static func make_transfer() -> void:
	pass


# checks the contract of your team and returns the players that run out 
# the next 6, 3, 1 months in and according json
static func check_contracts_your_team(players:Array) -> void:
	pass
	
# checks the contract of all other teams and decides depending on teams
# settings and players age and abilities, if team makes new contract or even sells
# the player. before the contract runs out 
static func check_contracts_other_teams() -> void:
	pass


# validates if the team should keep or sell the player
# or make run out the ccntract
static func valdiate_player(team, player) -> void:
	pass
	
