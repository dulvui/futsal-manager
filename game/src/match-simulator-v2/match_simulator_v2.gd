# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name MatchSimulator

signal action_message
signal half_time
signal match_end
signal update

@onready var match_engine:Node = $SubViewportContainer/SubViewport/MatchEngine

# seconds for halftime
const half_time_seconds:int = 60 * 20

var ticks:int = 0
var time:int = 0
var timer:Timer
# stats
var possession_counter:float = 0.0
var home_stats:MatchStatistics = MatchStatistics.new()
var away_stats:MatchStatistics = MatchStatistics.new()

#var home_has_ball:bool
func set_up(home_team:Team, away_team:Team, match_seed:int) -> void:
	match_engine.set_up(home_team,away_team, match_seed)
	
	# intialize timer
	timer = Timer.new()
	timer.wait_time = 1.0 / (Constants.ticks_per_second * Config.speed_factor)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	match_engine.update()
	ticks += 1
	if ticks == Constants.ticks_per_second:
		ticks = 0
		time += 1
		_update_time()

func _update_time() -> void:
	update.emit()
	# check half/end time
	if time == half_time_seconds:
		timer.paused = true
		half_time.emit()
		match_engine.half_time()
	elif time == half_time_seconds * 2:
		timer.stop()
		match_end.emit()
	# update posession stats
	if match_engine.home_team.has_ball:
		possession_counter += 1.0
	home_stats.possession = (possession_counter / time) * 100
	away_stats.possession = 100 - home_stats.possession

func pause_toggle() -> bool:
	timer.paused = not timer.paused
	return timer.paused


func pause() -> void:
	timer.paused = true


func continue_match() -> void:
	timer.paused = false


func match_finished() -> void:
	timer.stop()


func faster() -> void:
	timer.wait_time /= 2


func slower() -> void:
	timer.wait_time *= 2


func start_match() -> void:
	timer.start()


func change_players(home_team:Team,away_team:Team) -> void:
	match_engine.change_players(home_team,away_team)


func _on_ActionUtil_action_message(message:String) -> void:
	emit_signal("action_message", message)

func _on_match_engine_away_goal() -> void:
	away_stats.goals += 1

func _on_match_engine_home_goal() -> void:
	home_stats.goals += 1
