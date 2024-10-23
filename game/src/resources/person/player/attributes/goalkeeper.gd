# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Goalkeeper
extends JSONResource

const AMOUNT: int = 6

@export var reflexes: int
@export var positioning: int
@export var kicking: int
@export var handling: int
@export var diving: int
@export var speed: int


func _init(
	p_reflexes: int = Const.MAX_PRESTIGE,
	p_positioning: int = Const.MAX_PRESTIGE,
	p_kicking: int = Const.MAX_PRESTIGE,
	p_handling: int = Const.MAX_PRESTIGE,
	p_diving: int = Const.MAX_PRESTIGE,
	p_speed: int = Const.MAX_PRESTIGE,
) -> void:
	reflexes = p_reflexes
	positioning = p_positioning
	kicking = p_kicking
	handling = p_handling
	diving = p_diving
	speed = p_speed


func sum() -> int:
	var value: int = 0
	value += reflexes
	value += positioning
	value += kicking
	value += handling
	value += diving
	value += speed
	return value


func average() -> int:
	return sum() / AMOUNT
