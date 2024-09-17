# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CupKnockout
extends Competition

@export var knockout: Knockout

func _init(
	p_knockout: Knockout = Knockout.new(),
) -> void:
	super()
	knockout = p_knockout


func set_up(teams: Array[Team]) -> void:
	knockout.set_up(teams)
