# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Formation

# first value is goalkeeper, seoncd defense etc...
enum Variations {
	F1202,
	F1121,
	F1112,
	F1211,
	F1103,
	F1301,
	F1400,
	# TODO add power play
	#F0023,
	#F0032,
	#F0014,
	#F0113
}

@export var variation:int

@export var goalkeeper:int
@export var defense:int
@export var center:int
@export var attack:int

# TODO extends with tactical information, like offensive/defense etc.

func _init(
	p_variation:Variations = Variations.F1202
) -> void:
	variation = p_variation
	set_variation(variation)

func set_variation(_variation:Variations) -> void:
	variation = _variation
	
	var string_values:PackedStringArray = Variations.keys()[variation].split()
	string_values.remove_at(0) # remove F
	
	# extract int values
	var int_values:Array[int] = []
	for value in string_values:
		var int_value:int = int(value)
		int_values.append(int_value)
	
	goalkeeper = int_values[0]
	defense = int_values[1]
	center = int_values[2]
	attack = int_values[3]
