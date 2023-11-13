# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const VisualAction:PackedScene = preload("res://src/match-simulator/visual-action/visual_action.tscn")

@onready var match_simulator:Node = $MatchSimulator
@onready var stats:MarginContainer = $HUD/HSplitContainer/CentralContainer/MainBar/Stats
@onready var comments:VBoxContainer = $HUD/HSplitContainer/CentralContainer/MainBar/Log
@onready var events:ScrollContainer = $HUD/HSplitContainer/CentralContainer/MainBar/Events
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var time_label:Label = $HUD/HSplitContainer/CentralContainer/TopBar/Labels/Time
@onready var result_label:Label = $HUD/HSplitContainer/CentralContainer/TopBar/Labels/Result

var last_active_view:Control

var home_team:Team
var away_team:Team

var match_started:bool = false
var first_half:bool = true


func _ready() -> void:
	randomize()
	var next_match:Dictionary = CalendarUtil.get_next_match()
	
	if next_match != null:
		for team in Config.league.teams:
			if team.name == next_match["home"]:
				home_team = team.duplicate(true)
			elif team.name == next_match["away"]:
				away_team = team.duplicate(true)
	
	$HUD/HSplitContainer/CentralContainer/TopBar/Labels/Home.text = next_match["home"]
	$HUD/HSplitContainer/CentralContainer/TopBar/Labels/Away.text = next_match["away"]
	
	$Formation.set_up()
	match_simulator.set_up(home_team,away_team)
	
	last_active_view = comments


func _on_match_simulator_update():
	stats.update_stats(match_simulator.home_stats, match_simulator.away_stats)
	time_label.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]
	
	$HUD/HSplitContainer/CentralContainer/TopBar/TimeBar.value = match_simulator.time
	$HUD/HSplitContainer/CentralContainer/BottomBar/PossessBar.value = match_simulator.home_stats.possession
	$HUD/HSplitContainer/CentralContainer/BottomBar/HBoxContainer/SpeedFactor.text = str(Config.speed_factor + 1) + " X"


func match_end() -> void:
	$HUD/HSplitContainer/CentralContainer/BottomBar/HBoxContainer/Faster.hide()
	$HUD/HSplitContainer/CentralContainer/BottomBar/HBoxContainer/Slower.hide()
	$HUD/HSplitContainer/CentralContainer/BottomBar/HBoxContainer/SpeedFactor.hide()
	$HUD/HSplitContainer/Buttons/Pause.hide()
	$HUD/HSplitContainer/Buttons/Dashboard.show()
	match_simulator.match_finished()
	Config.set_table_result(home_team.name,match_simulator.home_stats.goals,away_team.name,match_simulator.away_stats.goals)
	
	
	#simulate all games for now.
	for matchday in Config.calendar[Config.date.month][Config.date.day]["matches"]:
		if matchday["home"] != home_team["name"]:
			var random_home_goals = randi()%10
			var random_away_goals = randi()%10
			
			matchday["result"] = str(random_home_goals) + ":" + str(random_away_goals)
			print(matchday["home"] + " vs " + matchday["away"])
			Config.set_table_result(matchday["home"],random_home_goals,matchday["away"],random_away_goals)
		else:
			matchday["result"] = str(match_simulator.home_stats["goals"]) + ":" + str(match_simulator.away_stats["goals"])
#	Config.save_all_data()

	#save players history PoC
#	for real_player in home_team["players"]["active"]:
#		for copy_player in home_team["players"]["active"]:
#			if real_player["nr"] == copy_player["nr"]:
#				real_player["history"][Config.current_season]["actual"] = copy_player["history"][Config.current_season]["actual"]
#
#	for real_player in away_team_real["players"]["active"]:
#		for copy_player in away_team["players"]["active"]:
#			if real_player["nr"] == copy_player["nr"]:
#				real_player["history"][Config.current_season]["actual"] = copy_player["history"][Config.current_season]["actual"]

func half_time() -> void:
	$HUD/HSplitContainer/Buttons/Pause.text = tr("CONTINUE")


func _on_Field_pressed() -> void:
	_hide_views()
	comments.show()
	last_active_view = comments


func _on_Stats_pressed() -> void:
	_hide_views()
	stats.show()
	last_active_view = stats
	

func _on_Events_pressed() -> void:
	_hide_views()
	events.show()
	last_active_view = events
	
func _hide_views() -> void:
	comments.hide()
	stats.hide()
	events.hide()

func _toggle_view_buttons() -> void:
	$HUD/HSplitContainer/Buttons/Change.disabled = not $HUD/HSplitContainer/Buttons/Change.disabled 
	$HUD/HSplitContainer/Buttons/Events.disabled = not $HUD/HSplitContainer/Buttons/Events.disabled
	$HUD/HSplitContainer/Buttons/Stats.disabled = not $HUD/HSplitContainer/Buttons/Stats.disabled
	$HUD/HSplitContainer/Buttons/Field.disabled = not $HUD/HSplitContainer/Buttons/Field.disabled
	$HUD/HSplitContainer/Buttons/Formation.disabled = not $HUD/HSplitContainer/Buttons/Formation.disabled
	$HUD/HSplitContainer/Buttons/Tactics.disabled = not $HUD/HSplitContainer/Buttons/Tactics.disabled
	

func _on_Dashboard_pressed() -> void:
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_Faster_pressed() -> void:
	if Config.speed_factor < 3:
		Config.speed_factor += 1
		match_simulator.faster()


func _on_Slower_pressed() -> void:
	if Config.speed_factor > 0:
		Config.speed_factor -= 1
		match_simulator.slower()


func _on_Pause_pressed() -> void:
	var paused:bool = match_simulator.pause_toggle()
	
	if paused:
		$HUD/HSplitContainer/Buttons/Pause.text = tr("CONTINUE")
	else:
		$Formation.hide()
		$HUD/HSplitContainer/Buttons/Pause.text = tr("PAUSE")


func _on_Formation_pressed() -> void:
	match_simulator.pause()
	$HUD/HSplitContainer/Buttons/Pause.text = tr("CONTINUE")
	$Formation.show()


func _on_Formation_change() -> void:
	match_simulator.change_players(home_team,away_team)


func _on_SKIP_pressed() -> void:
	match_end()


func _on_MatchSimulator_shot(player:Object, on_target:bool, goal:bool) -> void:
	if not goal and randi() % Constants.VISUAL_ACTION_SHOTS_FACTOR > 0:
		# no goal, but show some shoots
		return
	
	# show visual action
	$HUD/HSplitContainer/Buttons/Pause.disabled = true
	match_simulator.pause()
	_hide_views()
	_toggle_view_buttons()
	
	# Visual Action
	var visual_action:Node2D = VisualAction.instantiate()
	visual_action.set_up(match_simulator.home_has_ball, goal, on_target, home_team, away_team, $MatchSimulator/ActionUtil.action_buffer)
	$HUD/HSplitContainer/CentralContainer/MainBar/VisualActionContainer.add_child(visual_action)
	await visual_action.action_finished
	
	if goal:
		$Goal.show()
		animation_player.play("Goal")
		await animation_player.animation_finished
		$Goal.hide()
		
		result_label.text = "%d - %d"%[match_simulator.home_stats.goals,match_simulator.away_stats.goals]
		
		events.append_text("%s  %s - %s  %s" % [time_label.text, str(match_simulator.home_stats.goals), str(match_simulator.away_stats.goals), player.name])

	
	visual_action.queue_free()
	match_simulator.continue_match()
	last_active_view.show()
	$HUD/HSplitContainer/Buttons/Pause.disabled = false
	_toggle_view_buttons()
	

func _on_StartTimer_timeout() -> void:
	match_simulator.start_match()


func _on_MatchSimulator_half_time() -> void:
	half_time()


func _on_MatchSimulator_match_end() -> void:
	match_end()


func _on_MatchSimulator_action_message(message:String) -> void:
	if comments.get_child_count() > 8:
		comments.remove_child(comments.get_child(0))
	var new_line:Label = Label.new()
	new_line.text = time_label.text + " " + message
	comments.add_child(new_line)

