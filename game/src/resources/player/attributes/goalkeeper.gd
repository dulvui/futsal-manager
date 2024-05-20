# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Goalkeeper
extends Resource

@export var reflexes: int
@export var positioning: int
@export var kicking: int
@export var handling: int
@export var diving: int
@export var speed: int

func _init(
	p_reflexes: int = 0,
	p_positioning: int = 0,
	p_kicking: int = 0,
	p_handling: int = 0,
	p_diving: int = 0,
	p_speed: int = 0,
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
	return sum() / 6
