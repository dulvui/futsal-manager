# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TeamSelect
extends Control

@onready var nations_container: HBoxContainer = $MarginContainer/VBoxContainer/NationSelect
@onready var team_list: VBoxContainer = $MarginContainer/VBoxContainer/Main/ScrollContainer/TeamList
@onready var team_profile: TeamProfile = $MarginContainer/VBoxContainer/Main/TeamProfile

var active_league: League
var active_team: Team


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	for nation: String in Const.Nations:
		var button: Button = Button.new()
		button.text = nation
		nations_container.add_child(button)
		button.pressed.connect(_on_nation_select.bind(nation))

	set_teams()
	var first_league: League = Config.world.get_all_leagues().get_leagues_by_nation(0)[0]
	active_league = first_league
	active_team = first_league.teams[0]
	team_profile.set_up(active_team)


func show_team(league: League, team: Team) -> void:
	active_league = league
	active_team = team
	team_profile.set_team(active_team)


func set_teams(nation: Const.Nations = 0) -> void:
	for child: Node in team_list.get_children():
		child.queue_free()

	for league: League in Config.world.get_all_leagues().get_leagues_by_nation(nation):
		var league_label: Label = Label.new()
		league_label.text = league.name
		team_list.add_child(league_label)
		UiUtil.bold(league_label)
		for team: Team in league.teams:
			var team_button: Button = Button.new()
			team_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			team_button.text = team.get_prestige_stars() + "  " + team.name
			team_button.pressed.connect(show_team.bind(league, team))
			team_list.add_child(team_button)


func _on_nation_select(nation: String) -> void:
	set_teams(Const.Nations.get(nation))
	var first_league: League = Config.world.get_all_leagues()[0]
	show_team(first_league, first_league.teams[0])


func _on_select_team_pressed() -> void:
	Config.select_team(active_league, active_team)
	print("team saved")
	Config.world.initialize_calendars()
	print("calendars created")
	MatchMaker.inizialize_matches(Config.world.get_all_leagues())
	print("matches initialized")
	EmailUtil.welcome_manager()

	Config.save_states.make_temp_active()
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/start_game/start_game.tscn")
