# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal action_message
signal half_time
signal match_end
signal update

@onready var action_util:Node = $SubViewportContainer/SubViewport/ActionUtilV2

# seconds for halftime
const half_time_seconds:int = 12000
# time splitting
const ticks_per_second:int = 4
var ticks:int = 0
var time:int = 0
var timer:Timer
# stats
var possession_counter:float = 0.0
var home_stats:MatchStatistics = MatchStatistics.new()
var away_stats:MatchStatistics = MatchStatistics.new()

#var home_has_ball:bool
func set_up(home_team:Team, away_team:Team) -> void:
	action_util.set_up(home_team,away_team)
	
	for speed in Config.speed_factor:
		faster()
	
	# intialize timer
	timer = Timer.new()
	timer.wait_time = 1.0 / ticks_per_second
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	action_util.update()
	ticks += 1
	if ticks == ticks_per_second:
		ticks = 0
		time += 1
		_update()

func _update() -> void:
	update.emit()
	# check half/end time
	if time == half_time_seconds:
		timer.paused = true
		half_time.emit()
		action_util.half_time()
	elif time == half_time_seconds * 2:
		timer.stop()
		match_end.emit()
	# update posession stats
	if action_util.home_team.has_ball:
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
	timer.wait_time /= Constants.MATCH_SPEED_FACTOR


func slower() -> void:
	timer.wait_time *= Constants.MATCH_SPEED_FACTOR


func start_match() -> void:
	timer.start()


func change_players(home_team:Team,away_team:Team) -> void:
	action_util.change_players(home_team,away_team)


func _on_ActionUtil_action_message(message:String) -> void:
	emit_signal("action_message", message)


func _on_action_util_shot(player:Player, on_target:bool, success:bool) -> void:
	print("match_sim home_has ball " + str(action_util.home_team.has_ball))
	if action_util.home_team.has_ball:
		home_stats.shots += 1
		if on_target:
			home_stats.shots_on_target += 1
		if success:
			home_stats.goals += 1
			player.statistics[Config.current_season].goals += 1
	else:
		away_stats.shots += 1
		if on_target:
			away_stats.shots_on_target += 1
		if success:
			away_stats.goals += 1
			player.statistics[Config.current_season].goals += 1


#func _on_action_util_possession_change() -> void:
	#home_has_ball = not home_has_ball

# STATS

func _on_action_util_corner(_player:Player) -> void:
	if action_util.home_team.has_ball:
		home_stats.corners += 1
	else:
		away_stats.corners += 1


func _on_action_util_foul(_player:Player) -> void:
	if not action_util.home_team.has_ball:
		home_stats.fouls += 1
	else:
		away_stats.fouls += 1


func _on_action_util_freekick(_player:Player) -> void:
	if action_util.home_team.has_ball:
		home_stats.free_kicks += 1
	else:
		away_stats.free_kicks += 1


func _on_action_util_kick_in(_player:Player) -> void:
	if action_util.home_team.has_ball:
		home_stats.kick_ins += 1
	else:
		away_stats.kick_ins += 1


func _on_action_util_pazz(_player:Player, success:bool) -> void:
	if success:
		if action_util.home_team.has_ball:
			home_stats.passes += 1
		else:
			away_stats.passes += 1


func _on_action_util_penalty(_player:Player) -> void:
	if action_util.home_team.has_ball:
		home_stats.penalties += 1
	else:
		away_stats.penalties += 1


func _on_action_util_red_card(_player:Player) -> void:
	if not action_util.home_team.has_ball:
		home_stats.red_cards += 1
	else:
		away_stats.red_cards += 1


func _on_action_util_yellow_card(_player:Player) -> void:
	if not action_util.home_team.has_ball:
		home_stats.yellow_cards += 1
	else:
		away_stats.yellow_cards += 1





