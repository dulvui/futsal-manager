# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Continent
extends JSONResource

@export var name: String
@export var nations: Array[Nation]
@export var cup_clubs: CupMixedStage
@export var cup_nations: CupMixedStage


func _init(
	p_name: String = "",
	p_nations: Array[Nation] = [],
	p_cup_clubs: CupMixedStage = CupMixedStage.new(),
	p_cup_nations: CupMixedStage = CupMixedStage.new(),
) -> void:
	name = p_name
	nations = p_nations
	cup_clubs = p_cup_clubs
	cup_nations = p_cup_nations
