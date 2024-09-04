# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualMatchList
extends Control

const MatchRowScene: PackedScene = preload(
	"res://src/ui_components/visual_calendar/match_list/match_list_row/match_list_row.tscn"
)

@onready var matches_list: VBoxContainer = $VBoxContainer/ScrollContainer/Matches
@onready var date_label: Label = $VBoxContainer/Date


func set_up(day: Day) -> void:
	date_label.text = day.to_format_string()

	for child: Node in matches_list.get_children():
		child.queue_free()

	# add active league games
	if day.get_matches().size() > 0:
		var active_league_label: Label = Label.new()
		active_league_label.text = Config.league.name
		UiUtil.bold(active_league_label)
		matches_list.add_child(active_league_label)
		for matchz: Match in day.get_matches():
			var match_row: MatchListRow = MatchRowScene.instantiate()
			matches_list.add_child(match_row)
			match_row.set_up(matchz)

		matches_list.add_child(HSeparator.new())

	# add other leagues matches
	for league: League in Config.world.get_all_leagues():
		if league.id != Config.league.id:
			var matches: Array = Config.world.calendar.day(day.month, day.day).get_matches(league.id)
			if matches.size() > 0:
				var league_label: Label = Label.new()
				league_label.text = league.name
				UiUtil.bold(league_label)
				matches_list.add_child(league_label)
				for matchz: Match in matches:
					var match_row: MatchListRow = MatchRowScene.instantiate()
					matches_list.add_child(match_row)
					match_row.set_up(matchz)

				matches_list.add_child(HSeparator.new())
