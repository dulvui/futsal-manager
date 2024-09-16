# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CupMixedStage
extends Competition

@export var groups: Array[CupGroup]
@export var knockout: Knockout

func _init(
	p_groups: Array[CupGroup] = [],
	p_knockout: Knockout = Knockout.new(),
) -> void:
	super()
	groups = p_groups
	knockout = p_knockout


func add_teams(_teams: Array[Team]) -> void:
	# TODO fill groups with teams
	pass
