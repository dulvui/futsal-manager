# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name MatchSimulator

signal action_message
signal half_time
signal match_end
signal update

@onready var visual_match:Node2D = $SubViewportContainer/SubViewport/VisualMatch

var ticks:int = 0
var time:int = 0
var timer:Timer

#var home_has_ball:bool
func set_up(home_team:Team, away_team:Team, match_seed:int) -> void:
	visual_match.set_up(home_team,away_team, match_seed)
	
	# intialize timer
	timer = Timer.new()
	timer.wait_time = 1.0 / (Constants.ticks_per_second * Config.speed_factor)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout() -> void:
	visual_match.update()
	ticks += 1
	if ticks == Constants.ticks_per_second:
		ticks = 0
		time += 1
		_update_time()


func _update_time() -> void:
	update.emit()
	# check half/end time
	if time == Constants.half_time_seconds:
		timer.paused = true
		half_time.emit()
		visual_match.half_time()
	elif time == Constants.half_time_seconds * 2:
		timer.stop()
		match_end.emit()


func pause_toggle() -> bool:
	timer.paused = not timer.paused
	return timer.paused


func pause() -> void:
	timer.paused = true


func continue_match() -> void:
	timer.paused = false


func match_finished() -> void:
	timer.stop()


func set_time() -> void:
	timer.wait_time = 1.0 / (Constants.ticks_per_second * Config.speed_factor)


func start_match() -> void:
	timer.start()


func change_players(home_team:Team,away_team:Team) -> void:
	visual_match.change_players(home_team,away_team)

