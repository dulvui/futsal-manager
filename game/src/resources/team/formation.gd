# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Formation

enum Variations { F22, F121, F112, F211, F13, F31, F40 }

@export var variation:int

@export var goalkeeper:int
@export var defense:int
@export var center:int
@export var attack:int

# TODO extends with tactical information, like offensive/defense etc.

func _init(
	p_variation:Variations = Variations.F22
) -> void:
	variation = p_variation
	set_variation(variation)

func set_variation(_variation:Variations) -> void:
	variation = _variation
	goalkeeper = 1
	match variation:
		Variations.F22:
			defense = 2
			attack = 2
		Variations.F121:
			defense = 1
			center = 2
			attack = 1
		_:
			defense = 2
			attack = 2
