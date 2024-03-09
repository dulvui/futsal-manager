# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const match_row_scene:PackedScene = preload("res://src/ui-components/visual-calendar/match-list/match-list-row/match_list_row.tscn")

@onready var matches_list:VBoxContainer = $ScrollContainer/Matches

func set_up(day:Day) -> void:
	for child:Node in matches_list.get_children():
		child.queue_free()
	
	# add active league games
	var active_league_label:Label = Label.new()
	active_league_label.text = Config.leagues.get_active().name
	UiUtil.bold(active_league_label)
	matches_list.add_child(active_league_label)
	for matchz:Match in day.matches:
		var match_row:MatchListRow = match_row_scene.instantiate()
		matches_list.add_child(match_row)
		match_row.set_up(matchz)
	
	matches_list.add_child(HSeparator.new())
	
	# add other leagues matches
	for league:League in Config.leagues.get_others():
		var league_label:Label = Label.new()
		league_label.text = league.name
		UiUtil.bold(league_label)
		matches_list.add_child(league_label)
		for matchz:Match in league.calendar.day(day.month, day.day).matches:
			var match_row:MatchListRow = match_row_scene.instantiate()
			matches_list.add_child(match_row)
			match_row.set_up(matchz)

		matches_list.add_child(HSeparator.new())
