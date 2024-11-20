# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualMatchList
extends Control

const MatchInfoScene: PackedScene = preload(
	"res://src/ui_components/visual_calendar/match_list/match_info/match_info.tscn"
	)

@onready var matches_list: VBoxContainer = %Matches
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var date_label: Label = %Date


func setup(day: Day, competition: Competition = Global.league) -> void:
	# remove children
	for child: Node in matches_list.get_children():
		child.queue_free()
	
	# reset scroll posiiton
	scroll_container.scroll_horizontal = 0
	scroll_container.scroll_vertical = 0

	date_label.text = day.to_format_string()

	# add active competition games to top
	_add_matches(day, competition)

	# if active competition is a Legue, show other leagues first
	# otherwise show other cups first
	if competition is League:
		var active_league: League = (competition as League)

		# add leagues
		var leagues: Array[League] = Global.world.get_all_leagues()
		# add  leagues with same nation as active first
		for league: League in leagues:
			if league.id != Global.league.id and league.nation_name == active_league.nation_name:
				_add_matches(day, league)
		# add other nations
		for league: League in leagues:
			if league.nation_name != active_league.nation_name:
				_add_matches(day, league)

		# add cups
		for cup: Cup in Global.world.get_all_cups():
			_add_matches(day, cup)
	else:
		# add cups
		for cup: Cup in Global.world.get_all_cups():
			_add_matches(day, cup)
		# add other leagues matches
		for league: League in Global.world.get_all_leagues():
			if league.id != Global.league.id:
				_add_matches(day, league)
	
	if matches_list.is_empty()



func _add_matches(day: Day, competition: Competition) -> void:
	# get matches by competition
	var matches: Array = Global.world.calendar.day(day.month, day.day).get_matches(competition.id)
	# add to list
	if matches.size() > 0:
		var competition_label: Label = Label.new()
		competition_label.text = competition.name
		if competition is League:
			competition_label.text += " - %s"%(competition as League).nation_name
		ThemeUtil.bold(competition_label)
		matches_list.add_child(competition_label)
		for matchz: Match in matches:
			var match_row: MatchInfo = MatchInfoScene.instantiate()
			matches_list.add_child(match_row)
			match_row.setup(matchz)

		matches_list.add_child(HSeparator.new())
