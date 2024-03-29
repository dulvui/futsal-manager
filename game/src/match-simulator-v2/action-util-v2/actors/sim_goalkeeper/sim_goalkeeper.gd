# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimGoalkeeper

@onready var sprites:Node2D = $Sprites

func update() -> void:
	decide()
	
func decide() -> void:
	pass
