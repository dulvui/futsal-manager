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
@export var variations: Array[PositionVariation]


func _init(
	p_name: String = "",
	p_description: String = "",
	p_coordinates: Vector2 = Vector2.ZERO,
	p_type: Type = Type.G,
	p_variations: Array[PositionVariation] = []
	) -> void:
	name = p_name
	description = p_description
	coordinates = p_coordinates
	type = p_type
	variations = p_variations


func random_variations() -> void:
	var base: Array
	match type:
		Type.G:
			base = PositionVariation.G.keys()
		Type.DL, Type.DC, Type.DR:
			base = PositionVariation.D.keys()
		Type.C:
			base = PositionVariation.C.keys()
		Type.WL, Type.WR:
			base = PositionVariation.W.keys()
		Type.PR, Type.PC, Type.PL:
			base = PositionVariation.P.keys()
	
	var size: int = base.size()
	for i: int in Config.rng.randi_range(1, size):
		var random_pick: int = Config.rng.randi_range(0, base.size() - 1)
		var variation: PositionVariation = PositionVariation.new()
		variation.type = base[random_pick]
		base.remove_at(random_pick)
		
		if i == 1:
			variation.confidence = 5
		else:
			variation.confidence = Config.rng.randi_range(1, 4)
		
		variations.append(variation)
	
	#print(variations)
