# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Transfer
extends Resource

enum State {
	OFFER,
	OFFER_PENDING,
	CONTRACT,
	CONTRACT_PENDING,
	SUCCESS,
}

@export var player:Player
@export var state:State
@export var buy_team:Team
@export var sell_team:Team
@export var price:int
@export var contract:Contract
@export var delay_days:int

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
			var success:bool = randi()%2 == 0
			if success:
				state = State.CONTRACT
			else:
				state = State.OFFER
		State.CONTRACT_PENDING:
			var success:bool = randi()%2 == 0
			if success:
				state = State.SUCCESS
			else:
				state = State.CONTRACT
			
