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

@export var id:int
@export var foreign_id:int # used to connect email to resource like a transfer
@export var type:Type
@export var subject:String
@export var text:String
@export var sender:String
@export var date:String
@export var read:bool

func _init(
	p_id:int = IdUtil.next_id(IdUtil.Types.EMAIL),
	p_type:Type = Type.NEXT_MATCH,
	p_subject:String = "",
	p_text:String = "",
	p_sender:String = "",
	p_date:String = "",
	p_read:bool = false,
	) -> void:
	id = p_id
	type = p_type
	subject = p_subject
	text = p_text
	sender = p_sender
	date = p_date
	read = p_read

