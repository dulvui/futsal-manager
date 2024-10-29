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
	_add_matches(Global.league, day)

	# add other leagues matches
	for league: League in Global.world.get_all_leagues():
		if league.id != Global.league.id:
			_add_matches(league, day)

	# add cups
	for cup: Competition in Global.world.get_all_club_cups():
		_add_matches(cup, day)


func _add_matches(competition: Competition, day: Day) -> void:
	# get matches by competition
	var matches: Array = Global.world.calendar.day(day.month, day.day).get_matches(competition.id)
	# add to list
	if matches.size() > 0:
		var competition_label: Label = Label.new()
		competition_label.text = competition.name
		ThemeUtil.bold(competition_label)
		matches_list.add_child(competition_label)
		for matchz: Match in matches:
			var match_row: MatchListRow = MatchRowScene.instantiate()
			matches_list.add_child(match_row)
			match_row.set_up(matchz)

		matches_list.add_child(HSeparator.new())
