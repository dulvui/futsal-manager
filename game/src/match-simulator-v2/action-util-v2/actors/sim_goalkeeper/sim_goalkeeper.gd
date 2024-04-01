# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimGoalkeeper

@onready var body:Sprite2D = $Sprites/Body

func set_color(p_color:Color) -> void:
	body.modulate = p_color

func act() -> void:
	pass
	
