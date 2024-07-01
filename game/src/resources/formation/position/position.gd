# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Position
extends Resource

# 9X9 grid + goalkeeper
enum Type {
	G,
	DL,
	DC,
	DR,
	C,
	WL,
	WR,
	PL,
	PC,
	PR,
}

@export var name: String
@export var description: String
@export var coordinates: Vector2
@export var type: Type
@export var variations: Array[Position]


func _init(
	p_name: String = "",
	p_description: String = "",
	p_coordinates: Vector2 = Vector2.ZERO,
	p_type: Type = Type.G,
	p_variations: Array[Position] = []
	) -> void:
	name = p_name
	description = p_description
	coordinates = p_coordinates
	type = p_type
	variations = p_variations
