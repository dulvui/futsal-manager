# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Goalkeeper

@export var reflexes: int
@export var positioning: int
@export var kicking: int
@export var handling: int
@export var diving: int
@export var speed: int

func get_attributes() -> int:
	var value = 0
	value += reflexes
	value += positioning
	value += kicking
	value += handling
	value += diving
	value += speed
	return value
