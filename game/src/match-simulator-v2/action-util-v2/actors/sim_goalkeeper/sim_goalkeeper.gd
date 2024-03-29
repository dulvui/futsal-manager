# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimGoalkeeper

@onready var sprites:Node2D = $Sprites

func set_up(p_player_res:Player, p_start_pos:Vector2, p_ball:SimBall) -> void:
	super.set_up(p_player_res, p_start_pos, p_ball)

func update() -> void:
	decide()
	
func decide() -> void:
	pass
