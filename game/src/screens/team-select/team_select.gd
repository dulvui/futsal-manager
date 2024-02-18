# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var nations_container:HBoxContainer = $VBoxContainer/NationSelect
@onready var team_list:VBoxContainer = $VBoxContainer/HSplitContainer/ScrollContainer/TeamList

var active_league:League
var active_team:Team

func _ready() -> void:
	for nation:String in Constants.Nations:
		var button:Button = Button.new()
		button.text = nation
		nations_container.add_child(button)
		button.pressed.connect(_on_nation_select.bind(nation))
	
	set_teams()

func show_team(league:League, team:Team) -> void:
	active_league = league
	active_team = team
	pass

func set_teams(nation:Constants.Nations = 0) -> void:
	for child:Node in team_list.get_children():
		child.queue_free()
	
	for league:League in Config.leagues.get_leagues_by_nation(nation):
		var league_label:Label = Label.new()
		league_label.text = league.name
		team_list.add_child(league_label)
		for team:Team in league.teams:
			var team_button:Button = Button.new()
			team_button.text = team.name
			team_button.pressed.connect(show_team.bind(league, team))
			team_list.add_child(team_button)

func _on_nation_select(nation:String) -> void:
	print(nation)
	set_teams(Constants.Nations.get(nation))


func _on_select_team_pressed() -> void:
	Config.select_team(active_league,active_team)
	print("team saved")
	CalendarUtil.create_calendar()
	print("calendar created")
	MatchMaker.inizialize_matches()
	print("matches initialized")
	EmailUtil.welcome_manager()
	
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
