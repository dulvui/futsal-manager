# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Formation
extends JSONResource

# first value is goalkeeper, second defense etc...
enum Variations {
	F1202,
	F1121,
	F1112,
	F1211,
	F1103,
	F1301,
	F1400,
}

# defines if automated changes and strategy
enum ChangeStrategy {
	# change players if stamina is low
	AUTO,
	# manual change
	MANUAL,
}

@export var variation: Variations
@export var change_strategy: ChangeStrategy

@export var goalkeeper: int
@export var defense: int
@export var center: int
@export var attack: int

@export var tactic_defense: TacticDefense
@export var tactic_offense: TacticOffense

@export var positions: Array[Position]


func _init(
	p_variation: Variations = Variations.F1121,
	p_change_strategy: ChangeStrategy = ChangeStrategy.AUTO,
	p_tactic_defense: TacticDefense = TacticDefense.new(),
	p_tactic_offense: TacticOffense = TacticOffense.new(),
	p_positions: Array[Position] = [],
) -> void:
	variation = p_variation
	change_strategy = p_change_strategy
	tactic_defense = p_tactic_defense
	tactic_offense = p_tactic_offense
	positions = p_positions
	
	set_variation(variation)


func set_variation(p_variation: Variations) -> void:
	variation = p_variation
	var string_values: PackedStringArray = str(Variations.keys()[variation]).split()
	string_values.remove_at(0)  # remove F character from Variations key string

	# extract int values
	var int_values: Array[int] = []
	for value in string_values:
		var int_value: int = int(value)
		int_values.append(int_value)

	goalkeeper = int_values[0]
	defense = int_values[1]
	center = int_values[2]
	attack = int_values[3]

