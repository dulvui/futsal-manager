# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends TabContainer

const PlayerProfile:PackedScene = preload("res://src/ui-components/player-profile/player_profile.tscn")


func _ready() -> void:
	for league:League in Config.leagues.list:
		var center_container:CenterContainer = CenterContainer.new()
		center_container.name = league.name
		var grid:GridContainer = GridContainer.new()
		grid.columns = 2
		for team:Team in league["teams"]:
			var team_button:Button = Button.new()
			team_button.text = team["name"]
			team_button.pressed.connect(team_selected.bind(league, team))
			grid.add_child(team_button)
		center_container.add_child(grid)
		add_child(center_container)

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
