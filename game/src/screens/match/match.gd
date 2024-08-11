# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name MatchScreen
extends Control

const MAX_SPEED_FACTOR: int = 20
const MAX_COMMENTS: int = 16

#@onready var match_simulator: MatchSimulator = $Main/Content/CentralContainer/MainBar/MatchSimulator
@onready var match_simulator: MatchSimulator = $MatchSimulator
@onready var stats: VisualMatchStats = $Main/Content/CentralContainer/MainBar/Stats
@onready var comments: VBoxContainer = $Main/Content/CentralContainer/MainBar/Log
@onready var events: ScrollContainer = $Main/Content/CentralContainer/MainBar/Events
@onready var formation: VisualFormation = $Main/Content/CentralContainer/MainBar/Formation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var time_label: Label = $Main/Content/CentralContainer/TopBar/Time
@onready var result_label: Label = $Main/Content/CentralContainer/TopBar/Result
@onready var pause_button: Button = $Main/Content/Buttons/Pause
@onready var home_color: ColorRect = $Main/Content/CentralContainer/TopBar/HomeColor
@onready var away_color: ColorRect = $Main/Content/CentralContainer/TopBar/AwayColor
@onready var speed_factor_label: Label = $Main/Content/Buttons/Speed/SpeedFactor
@onready var home_possession: Label = $Main/Content/CentralContainer/BottomBar/PossessBar/Labels/Home
@onready var away_possession: Label = $Main/Content/CentralContainer/BottomBar/PossessBar/Labels/Away
@onready var home_name: Label = $Main/Content/CentralContainer/TopBar/Home
@onready var away_name: Label = $Main/Content/CentralContainer/TopBar/Away
@onready var time_bar: ProgressBar = $Main/Content/CentralContainer/TopBar/TimeBar
@onready var possess_bar: ProgressBar = $Main/Content/CentralContainer/BottomBar/PossessBar

@onready var faster_button: Button = $Main/Content/Buttons/Speed/Faster
@onready var slower_button: Button = $Main/Content/Buttons/Speed/Slower
@onready var dashboard_button: Button = $Main/Content/Buttons/Dashboard
@onready var change_button: Button = $Main/Content/Buttons/Change
@onready var events_button: Button = $Main/Content/Buttons/Events
@onready var stats_button: Button = $Main/Content/Buttons/Stats
@onready var field_button: Button = $Main/Content/Buttons/Field
@onready var formation_button: Button = $Main/Content/Buttons/Formation
@onready var tactics_button: Button = $Main/Content/Buttons/Tactics

var last_active_view: Control

var home_team: Team
var away_team: Team

var match_started: bool = false
var first_half: bool = true

var matchz: Match

var home_stats: MatchStatistics
var away_stats: MatchStatistics


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	# setup automatically, if run in editor and is run by 'Run current scene'
	if OS.has_feature("editor") and get_parent() == get_tree().root:
		matchz = Match.new()
		# games needs to be started at least once with a valid save state
		matchz.home = Config.league.teams[0]
		matchz.away = Config.league.teams[1]
	else:
		matchz = Config.calendar.get_next_match()

	for team: Team in Config.league.teams:
		if team.id == matchz.home.id:
			home_team = team
		elif team.id == matchz.away.id:
			away_team = team

	home_name.text = matchz.home.name
	away_name.text = matchz.away.name

	formation.set_up(true)
	match_simulator.set_up(home_team, away_team, matchz.id)

	last_active_view = match_simulator

	# set colors
	home_color.color = home_team.get_home_color()
	away_color.color = away_team.get_away_color(home_color.color)

	speed_factor_label.text = str(Config.speed_factor) + " X"

	# to easier access stats
	home_stats = match_simulator.visual_match.match_engine.home_team.stats
	away_stats = match_simulator.visual_match.match_engine.away_team.stats


func _on_match_simulator_update_time() -> void:
	stats.update_stats(home_stats, away_stats)
	time_label.text = "%02d:%02d" % [int(match_simulator.time) / 60, int(match_simulator.time) % 60]

	time_bar.value = match_simulator.time
	possess_bar.value = home_stats.possession

	home_possession.text = str(home_stats.possession) + " %"
	away_possession.text = str(away_stats.possession) + " %"
	result_label.text = "%d - %d" % [home_stats.goals, away_stats.goals]


func match_end() -> void:
	faster_button.hide()
	slower_button.hide()
	speed_factor_label.hide()
	pause_button.hide()
	dashboard_button.show()
	match_simulator.match_finished()
	Config.league.table.add_result(
		home_team.id, home_stats.goals, away_team.id, away_stats.goals
	)

	#assign result
	matchz.set_result(home_stats.goals, away_stats.goals)
	# calc other matches
	Config.world.get_all_leagues().random_results()
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
	print(" TODO change formation in match engine")


func _hide_views() -> void:
	comments.hide()
	stats.hide()
	events.hide()
	formation.hide()
	match_simulator.hide()


func _toggle_view_buttons() -> void:
	change_button.disabled = not change_button.disabled
	events_button.disabled = not events_button.disabled
	stats_button.disabled = not stats_button.disabled
	field_button.disabled = not field_button.disabled
	formation_button.disabled = not formation_button.disabled
	tactics_button.disabled = not tactics_button.disabled


func _on_Dashboard_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_Faster_pressed() -> void:
	if Config.speed_factor < MAX_SPEED_FACTOR:
		Config.speed_factor += 1
		match_simulator.set_time()
	speed_factor_label.text = str(Config.speed_factor) + " X"


func _on_Slower_pressed() -> void:
	if Config.speed_factor > 1:
		Config.speed_factor -= 1
		match_simulator.set_time()
	speed_factor_label.text = str(Config.speed_factor) + " X"


func _on_Pause_pressed() -> void:
	var paused: bool = match_simulator.pause_toggle()
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


func _on_match_simulator_action_message(message: String) -> void:
	if comments.get_child_count() > MAX_COMMENTS:
		comments.remove_child(comments.get_child(0))
	var new_line: Label = Label.new()
	new_line.text = time_label.text + " " + message
	comments.add_child(new_line)
