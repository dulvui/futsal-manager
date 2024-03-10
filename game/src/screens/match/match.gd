# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const VisualAction:PackedScene = preload("res://src/match-simulator/visual-action/visual_action.tscn")

@onready var match_simulator:Node = $MatchSimulator
@onready var stats:MarginContainer = $Main/Content/CentralContainer/MainBar/Stats
@onready var comments:VBoxContainer = $Main/Content/CentralContainer/MainBar/Log
@onready var events:ScrollContainer = $Main/Content/CentralContainer/MainBar/Events
@onready var formation:Control = $Main/Content/CentralContainer/MainBar/Formation
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var time_label:Label = $Main/Content/CentralContainer/TopBar/Time
@onready var result_label:Label = $Main/Content/CentralContainer/TopBar/Result
@onready var pause_button:Button = $Main/Content/Buttons/Pause
@onready var home_color:ColorRect = $Main/Content/CentralContainer/TopBar/HomeColor
@onready var away_color:ColorRect = $Main/Content/CentralContainer/TopBar/AwayColor
@onready var visual_action_container:Control = $VisualActionContainer
@onready var speed_factor_label:Label = $Main/Content/Buttons/Speed/SpeedFactor

@onready var home_possession:Label = $Main/Content/CentralContainer/BottomBar/PossessBar/Labels/Home
@onready var away_possession:Label = $Main/Content/CentralContainer/BottomBar/PossessBar/Labels/Away

const max_comments:int = 16
var last_active_view:Control

var home_team:Team
var away_team:Team

var match_started:bool = false
var first_half:bool = true

var matchz:Match

func _ready() -> void:
	randomize()
	matchz = Config.calendar().get_next_match()
	
	for team:Team in Config.leagues.get_active().teams:
		if team.name == matchz.home.name:
			home_team = team
		elif team.name == matchz.away.name:
			away_team = team
	
	$Main/Content/CentralContainer/TopBar/Home.text = matchz.home.name
	$Main/Content/CentralContainer/TopBar/Away.text = matchz.away.name
	
	formation.set_up(true)
	match_simulator.set_up(home_team,away_team)
	
	last_active_view = comments
	
	# set colors
	home_color.color = home_team.colors[0]
	if home_team.colors[0] != away_team.colors[1]:
		away_color.color = away_team.colors[1]
	else:
		away_color.color = away_team.colors[2]
		
	speed_factor_label.text = str(Config.speed_factor + 1) + " X"
	

func _on_match_simulator_update() -> void:
	stats.update_stats(match_simulator.home_stats, match_simulator.away_stats)
	time_label.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]
	
	$Main/Content/CentralContainer/TopBar/TimeBar.value = match_simulator.time
	$Main/Content/CentralContainer/BottomBar/PossessBar.value = match_simulator.home_stats.possession

	home_possession.text = str(match_simulator.home_stats.possession) + " %"
	away_possession.text = str(match_simulator.away_stats.possession) + " %"


func match_end() -> void:
	$Main/Content/Buttons/Speed/Faster.hide()
	$Main/Content/Buttons/Speed/Slower.hide()
	speed_factor_label.hide()
	pause_button.hide()
	$Main/Content/Buttons/Dashboard.show()
	match_simulator.match_finished()
	Config.leagues.get_active().table.add_result(home_team.name,match_simulator.home_stats.goals,away_team.name,match_simulator.away_stats.goals)
	
	
	#assign result
	matchz.set_result(match_simulator.home_stats["goals"],  match_simulator.away_stats["goals"])
	Config.save_all_data()

func half_time() -> void:
	pause_button.text = tr("CONTINUE")
	first_half = false


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

func _on_Formation_pressed() -> void:
	_hide_views()
	formation.show()
	match_simulator.pause()
	pause_button.text = tr("CONTINUE")


func _on_Formation_change() -> void:
	match_simulator.change_players(home_team,away_team)
	
func _hide_views() -> void:
	comments.hide()
	stats.hide()
	events.hide()
	formation.hide()

func _toggle_view_buttons() -> void:
	$Main/Content/Buttons/Change.disabled = not $Main/Content/Buttons/Change.disabled 
	$Main/Content/Buttons/Events.disabled = not $Main/Content/Buttons/Events.disabled
	$Main/Content/Buttons/Stats.disabled = not $Main/Content/Buttons/Stats.disabled
	$Main/Content/Buttons/Field.disabled = not $Main/Content/Buttons/Field.disabled
	$Main/Content/Buttons/Formation.disabled = not $Main/Content/Buttons/Formation.disabled
	$Main/Content/Buttons/Tactics.disabled = not $Main/Content/Buttons/Tactics.disabled
	

func _on_Dashboard_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_Faster_pressed() -> void:
	if Config.speed_factor < Constants.MATCH_SPEED_FACTOR:
		Config.speed_factor += 1
		match_simulator.faster()
	speed_factor_label.text = str(Config.speed_factor + 1) + " X"


func _on_Slower_pressed() -> void:
	if Config.speed_factor > 0:
		Config.speed_factor -= 1
		match_simulator.slower()
	speed_factor_label.text = str(Config.speed_factor + 1) + " X"


func _on_Pause_pressed() -> void:
	var paused:bool = match_simulator.pause_toggle()
	
	if paused:
		pause_button.text = tr("CONTINUE")
	else:
		pause_button.text = tr("PAUSE")
		_hide_views()
		last_active_view.show()


func _on_SKIP_pressed() -> void:
	match_end()


func _on_match_simulator_shot(player:Player, on_target:bool, goal:bool, action_buffer:Array[Action]) -> void:
	if not goal and randi() % Constants.VISUAL_ACTION_SHOTS_FACTOR > 0:
		# no goal, but show some shoots
		return
	
	# show visual action
	pause_button.disabled = true
	match_simulator.pause()
	_hide_views()
	_toggle_view_buttons()
	
	# Visual Action
	var visual_action:Node2D = VisualAction.instantiate()
	visual_action.set_up(first_half, goal, on_target, home_team, away_team, action_buffer, home_color.color, away_color.color)
	visual_action_container.add_child(visual_action)
	await visual_action.action_finished
	
	if goal:
		$Goal.show()
		animation_player.play("Goal")
		await animation_player.animation_finished
		$Goal.hide()
		result_label.text = "%d - %d"%[match_simulator.home_stats.goals,match_simulator.away_stats.goals]
		events.append_text("%s  %s - %s  %s" % [time_label.text, str(match_simulator.home_stats.goals), str(match_simulator.away_stats.goals), player.surname])
	
	visual_action.queue_free()
	match_simulator.continue_match()
	last_active_view.show()
	pause_button.disabled = false
	_toggle_view_buttons()

func _on_StartTimer_timeout() -> void:
	match_simulator.start_match()


func _on_match_simulator_half_time() -> void:
	half_time()


func _on_match_simulator_match_end() -> void:
	match_end()

func _on_match_simulator_action_message(message:String) -> void:
	if comments.get_child_count() > max_comments:
		comments.remove_child(comments.get_child(0))
	var new_line:Label = Label.new()
	new_line.text = time_label.text + " " + message
	comments.add_child(new_line)
