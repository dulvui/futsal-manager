# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Transfer
extends Resource

enum State {
	OFFER,
	OFFER_PENDING,
	OFFER_DECLINED,
	CONTRACT,
	CONTRACT_PENDING,
	SUCCESS,
	CONTRACT_DECLINED,
}

@export var player:Player
@export var state:State
@export var buy_team:Team
@export var sell_team:Team
@export var price:int
@export var contract:Contract
@export var delay_days:int
@export var exchange_players:Array[Player]


func _init(
	p_player:Player = Player.new(),
	p_state:State = State.OFFER,
	p_buy_team:Team = Team.new(),
	p_sell_team:Team = Team.new(),
	p_contract:Contract = Contract.new(),
	p_price:int = 0,
	p_delay_days:int = 0,
	p_exchange_players:Array[Player] = [],
) -> void:
	player = p_player
	state = p_state
	buy_team = p_buy_team
	sell_team = p_sell_team
	contract = p_contract
	price = p_price
	delay_days = p_delay_days
	exchange_players = p_exchange_players

func update() -> bool:
	# wait for user to make offer/contract
	if state == State.OFFER or state == State.CONTRACT:
		return false
	# reduce delay
	delay_days -= 1
	if delay_days == 0:
		delay_days = randi_range(3, 7)
		_update_state()
		return true
	return false

func accept_offer() -> void:
	state = State.CONTRACT

func _update_state() -> void:
	match state:
		State.OFFER_PENDING:
			# TODO use real values like prestige etc...
			var success:bool = randi()%2 == 0
			if success:
				state = State.CONTRACT
			else:
				var fail:bool = randi()%2 == 0
				if fail:
					state = State.OFFER_DECLINED
				else:
					state = State.OFFER
		State.CONTRACT_PENDING:
			var success:bool = randi()%2 == 0
			if success:
				state = State.SUCCESS
			else:
				var fail:bool = randi()%2 == 0
				if fail:
					state = State.CONTRACT_DECLINED
				else:
					state = State.CONTRACT
			
