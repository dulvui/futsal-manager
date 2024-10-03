# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualTable
extends VBoxContainer

@onready var grid: GridContainer = $ScrollContainer/GridContainer
@onready var leagues: SwitchOptionButton = $Buttons/Leagues
@onready var seasons: SwitchOptionButton = $Buttons/Seasons

var league_index: int
var season_index: int
var season_amount: int

func _ready() -> void:
	league_index = 0
	# start from last entry
	season_index = Config.league.tables.size() - 1
	season_amount = Config.league.tables.size()
	
	leagues.set_up(Config.world.get_all_leagues().map(func(league: League) -> String: return league.name))
	_set_up_seasons()
	
	_set_up()


func _set_up() -> void:
	# clear grid
	for child: Node in grid.get_children():
		child.queue_free()
	
	var league: League = Config.world.get_all_leagues()[league_index]
	
	var pos: int = 1
	
	# transform table dictionary to array
	var table_array: Array[TableValues] = league.tables[season_index].to_sorted_array()

	for team: TableValues in table_array:
		var pos_label: Label = Label.new()
		_style_label(pos_label)
		pos_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		pos_label.text = str(pos)
		pos += 1
		grid.add_child(pos_label)

		var name_label: Label = Label.new()
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.custom_minimum_size = Vector2(310, 0)
		name_label.text = team.team_name
		grid.add_child(name_label)

		var games_played_label: Label = Label.new()
		_style_label(games_played_label)
		games_played_label.text = str(team.wins + team.draws + team.lost)
		grid.add_child(games_played_label)

		var wins_label: Label = Label.new()
		_style_label(wins_label)
		wins_label.text = str(team.wins)
		grid.add_child(wins_label)

		var draws_label: Label = Label.new()
		_style_label(draws_label)
		draws_label.text = str(team.draws)
		grid.add_child(draws_label)

		var lost_label: Label = Label.new()
		_style_label(lost_label)
		lost_label.text = str(team.lost)
		grid.add_child(lost_label)

		var goals_made_label: Label = Label.new()
		_style_label(goals_made_label)
		goals_made_label.text = str(team.goals_made)
		grid.add_child(goals_made_label)

		var goals_against_label: Label = Label.new()
		_style_label(goals_against_label)
		goals_against_label.text = str(team.goals_against)
		grid.add_child(goals_against_label)

		var points_label: Label = Label.new()
		_style_label(points_label)
		points_label.text = str(team.points)
		grid.add_child(points_label)

		var label_settings: LabelSettings = LabelSettings.new()
		label_settings.font_size = get_theme_default_font_size()
		label_settings.font_color = Color.GOLD

		if team.team_name == Config.team.name:
			pos_label.label_settings = label_settings
			name_label.label_settings = label_settings
			games_played_label.label_settings = label_settings
			wins_label.label_settings = label_settings
			draws_label.label_settings = label_settings
			lost_label.label_settings = label_settings
			goals_made_label.label_settings = label_settings
			goals_against_label.label_settings = label_settings
			points_label.label_settings = label_settings


func _set_up_seasons() -> void:
	var start_year: int = Config.world.calendar.date.year
	var end_year: int = Config.world.calendar.date.year - season_amount
	
	var season_years: Array[String] = []
	for year: int in range(start_year, end_year, -1):
		season_years.append(str(year))
	seasons.set_up(season_years)


func _style_label(label: Label) -> void:
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.custom_minimum_size = Vector2(60, 0)


func _on_leagues_item_selected(index: int) -> void:
	league_index = index
	_set_up()


func _on_seasons_item_selected(index: int) -> void:
	# substract from season amount,
	# seasons are inserted inverted in options button
	# -1, because arrays start from 0
	season_index = season_amount - index - 1
	print(season_index)
	_set_up()
