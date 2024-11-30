# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GoalkeeperStateMachine
extends StateMachine


func update(p_team_has_ball: bool, p_is_touching_ball: bool) -> void:
	team_has_ball = p_team_has_ball
	is_touching_ball = p_is_touching_ball

	if not team_has_ball and ball.state == SimBall.State.SHOOT:
		speed = player_res.attributes.goalkeeper.reflexes
		state = State.SAVE_SHOT
	
	# reset save, if ball is no longer in shoot state
	if state == State.SAVE_SHOT and ball.state != SimBall.State.SHOOT:
		state = State.IDLE
		if team_has_ball:
			# back to base position
			set_destination(start_pos)
		else:
			goalkeeper_follow_ball()
		_move()

	match state:
		State.PASSING:
			state = State.IDLE
		State.POSITIONING:
			state = State.IDLE
		State.SAVE_SHOT:
			if _block_shot():
				ball.stop()
				state = State.IDLE
				ball.state = SimBall.State.GOALKEEPER
		State.IDLE:
			if is_touching_ball:
				state = State.PASSING
			else:
				state = State.POSITIONING



func _state_idle() -> void:
	if is_touching_ball:
		if team_has_ball:
			if _should_shoot():
				state = State.SHOOTING
			elif _should_pass():
				state = State.PASSING
			elif _should_dribble():
				state = State.DRIBBLE
		else:
			state = State.TACKLE
	else:
		state = State.MOVE


func _state_recive_pass() -> void:
	if is_touching_ball:
		state = State.IDLE


func _should_dribble() -> bool:
	# check something, but for now, nothing comes to my mind
	return RngUtil.match_rng.randi_range(1, 100) > 70


func _should_shoot() -> bool:
	if ball.empty_net:
		return true
	if ball.players_in_shoot_trajectory < 2:
		return RngUtil.match_rng.randi_range(1, 100) > 95
	return RngUtil.match_rng.randi_range(1, 100) > 98


func _should_pass() -> bool:
	if distance_to_player < 50:
		return RngUtil.match_rng.randi_range(1, 100) < 60
	return RngUtil.match_rng.randi_range(1, 100) < 10


func _block_shot() -> bool:
	if is_touching_ball:
		return (
			RngUtil.match_rng.randi_range(0, 100)
			< 69 + player_res.attributes.goalkeeper.handling * 2
		)
	return false
