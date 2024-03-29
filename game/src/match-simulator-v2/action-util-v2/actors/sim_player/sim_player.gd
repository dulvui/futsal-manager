# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimPlayer

enum Movement { STAND, WALK, RUN, SPRINT }

enum Attack { IDLE, PASS, CROSS, SHOOT, DRIBBLE }
enum AttackNoBall { IDLE, STAY_BACK, CUT_INSIDE, SUPPORT_PLAYER }

enum Defend { WAIT, MOVE, PASS, CROSS, SHOOT, DRIBBLE }

# state
var move_state:Movement

func set_up(p_player_res:Player, p_start_pos:Vector2, p_ball:SimBall) -> void:
	super.set_up(p_player_res, p_start_pos, p_ball)
	
func update() -> void:
	# TODO depeneding on Movement, subtract more or less
	stamina -= 0.01
	
	decide()
	move()
	
	if intercepts():
		#if randf() < 0.6:
			#short_pass.emit()
		#else:
			#shoot.emit()
		has_ball = true
		direction = pos.direction_to(Vector2.ZERO)
		ball.stop()
	
func move() -> void:
	super.move()
	
	if has_ball:
		ball.kick(direction, speed + 0.2)

func decide() -> void:
	pass
