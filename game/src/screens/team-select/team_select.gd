# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var nations_container:HBoxContainer = $VBoxContainer/NationSelect
@onready var team_list:VBoxContainer = $VBoxContainer/HSplitContainer/ScrollContainer/TeamList


func _ready() -> void:
	for nation:String in Constants.Nations:
		var button:Button = Button.new()
		button.text = nation
		nations_container.add_child(button)
		button.pressed.connect(_on_nation_select.bind(nation))
	
	set_teams()


func set_teams(nation:Constants.Nations = 0) -> void:
	for child:Node in team_list.get_children():
		child.queue_free()
	
	for league:League in Config.leagues.get_leagues_by_nation(nation):
		for team:Team in league.teams:
			var team_button:Button = Button.new()
			team_button.text = team.name
			team_button.pressed.connect(team_selected.bind(league, team))
			team_list.add_child(team_button)

func _on_nation_select(nation:String) -> void:
	print(nation)
	set_teams(Constants.Nations.get(nation))

func team_selected(league:League, team:Team) -> void:
	Config.select_team(league,team)
	print("team saved")
	CalendarUtil.create_calendar()
	print("calendar created")
	MatchMaker.inizialize_matches()
	print("matches initialized")
	EmailUtil.welcome_manager()
	
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
