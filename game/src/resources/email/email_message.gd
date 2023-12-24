# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name EmailMessage
extends Resource

enum Type {
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

@export var type:Type
@export var title:String
@export var message:String
@export var sender:String
@export var date:Dictionary
@export var read:bool

func _init(
	p_type:Type = Type.NEXT_MATCH,
	p_title:String = "",
	p_message:String = "",
	p_sender:String = "",
	p_date:Dictionary = {},
	p_read:bool = false,
	) -> void:
	type = p_type
	title = p_title
	message = p_message
	sender = p_sender
	date = p_date
	read = p_read

