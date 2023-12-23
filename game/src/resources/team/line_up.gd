# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name LineUp

@export var formation:Formation
@export var goalkeeper:Player
@export var players:Array[Player]
@export var substitutions:Array[Player]

func _init(
	p_formation:Formation = Formation.new(),
	p_goalkeeper:Player = Player.new(),
	p_players:Array[Player] = [],
	p_substitutions:Array[Player] = [],
) -> void:
	formation = p_formation
	goalkeeper = p_goalkeeper
	players = p_players
	substitutions = p_substitutions

