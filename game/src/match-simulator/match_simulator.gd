# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal shot(player:Player, on_target:bool, goal:bool, action_buffer:Array[Dictionary])
signal penalty(player:Player)

signal action_message
signal half_time
signal match_end
signal update

# seconds for halftime
const HALF_TIME:int = 1200

@onready var action_util:Node = $ActionUtil
@onready var timer:Timer = $Timer
var possession_counter:float = 0.0
var time:int = 0

var home_stats:MatchStatistics = MatchStatistics.new()
var away_stats:MatchStatistics = MatchStatistics.new()

var home_has_ball:bool


func set_up(home_team:Team, away_team:Team) -> void:
	action_util.set_up(home_team,away_team)
	
	for speed in Config.speed_factor:
		faster()


func _on_Timer_timeout() -> void:
	time += 1
	
	if time == HALF_TIME:
		timer.paused = true
		half_time.emit()
	elif time == HALF_TIME * 2:
		timer.stop()
		match_end.emit()
	
	action_util.update()
	update.emit()
	
	# update posession stats
	if home_has_ball:
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
	
	# coin toss for ball
	var coin:bool = randi() % 2 == 1
	action_util.home_team.has_ball = coin
	action_util.away_team.has_ball = not coin
	
	home_has_ball = coin


func change_players(home_team:Team,away_team:Team) -> void:
	action_util.change_players(home_team,away_team)


func _on_ActionUtil_action_message(message:String) -> void:
	emit_signal("action_message", message)


func _on_action_util_shot(player:Player, on_target:bool, success:bool) -> void:
	shot.emit(player, on_target , success, action_util.action_buffer)
	if home_has_ball:
		home_stats.shots += 1
		if on_target:
			home_stats.shots_on_target += 1
		if success:
			home_stats.goals += 1
			player.statistics[-1].goals += 1
	else:
		away_stats.shots += 1
		if on_target:
			away_stats.shots_on_target += 1
		if success:
			away_stats.goals += 1
			player.statistics[-1].goals += 1


func _on_action_util_possession_change() -> void:
	home_has_ball = not home_has_ball

# STATS

func _on_action_util_corner(player:Player) -> void:
	if home_has_ball:
		home_stats.corners += 1
	else:
		away_stats.corners += 1


func _on_action_util_foul(player:Player) -> void:
	if not home_has_ball:
		home_stats.fouls += 1
	else:
		away_stats.fouls += 1


func _on_action_util_freekick(player:Player) -> void:
	if home_has_ball:
		home_stats.free_kicks += 1
	else:
		away_stats.free_kicks += 1


func _on_action_util_kick_in(player:Player) -> void:
	if home_has_ball:
		home_stats.kick_ins += 1
	else:
		away_stats.kick_ins += 1


func _on_action_util_pazz(player:Player, success:bool) -> void:
	if home_has_ball:
		home_stats.passes += 1
	else:
		away_stats.passes += 1


func _on_action_util_penalty(player:Player) -> void:
	if home_has_ball:
		home_stats.penalties += 1
	else:
		away_stats.penalties += 1


func _on_action_util_red_card(player:Player) -> void:
	if not home_has_ball:
		home_stats.red_cards += 1
	else:
		away_stats.red_cards += 1


func _on_action_util_yellow_card(player:Player) -> void:
	if not home_has_ball:
		home_stats.yellow_cards += 1
	else:
		away_stats.yellow_cards += 1





