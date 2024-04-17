# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var match_simulator:MatchSimulator = $Main/Content/CentralContainer/MainBar/MatchSimulator
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
	matchz = Config.calendar().get_next_match()

	for team:Team in Config.leagues.get_active().teams:
		if team.name == matchz.home.name:
			home_team = team
		elif team.name == matchz.away.name:
			away_team = team

	$Main/Content/CentralContainer/TopBar/Home.text = matchz.home.name
	$Main/Content/CentralContainer/TopBar/Away.text = matchz.away.name

	formation.set_up(true)
	match_simulator.set_up(home_team,away_team, matchz.id)

	last_active_view = match_simulator

	# set colors
	home_color.color = home_team.get_home_color()
	away_color.color = away_team.get_away_color(home_color.color)

	speed_factor_label.text = str(Config.speed_factor) + " X"


func _on_match_simulator_update() -> void:
	stats.update_stats(match_simulator.visual_match.match_engine.home_stats, match_simulator.visual_match.match_engine.away_stats)
	time_label.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]

	$Main/Content/CentralContainer/TopBar/TimeBar.value = match_simulator.time
	$Main/Content/CentralContainer/BottomBar/PossessBar.value = match_simulator.visual_match.match_engine.home_stats.possession

	home_possession.text = str(match_simulator.visual_match.match_engine.home_stats.possession) + " %"
	away_possession.text = str(match_simulator.visual_match.match_engine.away_stats.possession) + " %"

	result_label.text = "%d - %d"%[match_simulator.visual_match.match_engine.home_stats.goals,match_simulator.visual_match.match_engine.away_stats.goals]


func match_end() -> void:
	$Main/Content/Buttons/Speed/Faster.hide()
	$Main/Content/Buttons/Speed/Slower.hide()
	speed_factor_label.hide()
	pause_button.hide()
	$Main/Content/Buttons/Dashboard.show()
	match_simulator.match_finished()
	Config.leagues.get_active().table.add_result(home_team.id,match_simulator.visual_match.match_engine.home_stats.goals,away_team.id,match_simulator.visual_match.match_engine.away_stats.goals)


	#assign result
	matchz.set_result(match_simulator.visual_match.match_engine.home_stats.goals,  match_simulator.visual_match.match_engine.away_stats.goals)
	# calc other matches
	#Config.leagues.random_results()
	Config.save_all_data()

func half_time() -> void:
	pause_button.text = tr("CONTINUE")
	first_half = false


func _on_Field_pressed() -> void:
	_hide_views()
	#comments.show()
	match_simulator.show()
	last_active_view = match_simulator


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
	match_simulator.hide()

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
	if Config.speed_factor < 6:
		Config.speed_factor += 1
		match_simulator.set_time()
	speed_factor_label.text = str(Config.speed_factor) + " X"


func _on_Slower_pressed() -> void:
	if Config.speed_factor > 1:
		Config.speed_factor -= 1
		match_simulator.set_time()
	speed_factor_label.text = str(Config.speed_factor) + " X"


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
