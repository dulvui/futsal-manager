# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends TabContainer

const PlayerProfile:PackedScene = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")


func _ready() -> void:
	DataSaver.init_teams()
	
	for nation in DataSaver.leagues:
		for league in DataSaver.leagues[nation]:
			var center_container:CenterContainer = CenterContainer.new()
			center_container.name = league["name"]
			var grid:GridContainer = GridContainer.new()
			grid.columns = 2
			for team in league["teams"]:
				var team_button:Button = Button.new()
				team_button.text = team["name"]
				team_button.pressed.connect(team_selected.bind(league["id"], team["name"]))
				grid.add_child(team_button)
			center_container.add_child(grid)
			add_child(center_container)

func team_selected(league_id, selected_team) -> void:
	DataSaver.select_team(league_id,selected_team)
	print("team saved")
	CalendarUtil.create_calendar()
	print("calendar created")
	MatchMaker.inizialize_matches()
	print("matches initialized")
	
	EmailUtil.new_message(EmailUtil.MessageTypes.WELCOME_MANAGER)
	
	DataSaver.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/Dashboard.tscn")
