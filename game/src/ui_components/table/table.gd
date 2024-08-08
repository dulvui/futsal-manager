# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualTable
extends VBoxContainer

@onready var grid: GridContainer = $ScrollContainer/GridContainer
@onready var leagues: SwitchOptionButton = $Leagues


func _ready() -> void:
	leagues.set_up(Config.leagues.list.map(func(league: League) -> String: return league.name))
	set_up()


func set_up(league: League = Config.league) -> void:
	# clear grid
	for child: Node in grid.get_children():
		child.queue_free()

	var pos: int = 1

	# transform table dictionary to array
	var table_array: Array = league.table.to_sorted_array()

	for team: TableValues in table_array:
		var pos_label: Label = Label.new()
		style_label(pos_label)
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
		style_label(games_played_label)
		games_played_label.text = str(team.wins + team.draws + team.lost)
		grid.add_child(games_played_label)

		var wins_label: Label = Label.new()
		style_label(wins_label)
		wins_label.text = str(team.wins)
		grid.add_child(wins_label)

		var draws_label: Label = Label.new()
		style_label(draws_label)
		draws_label.text = str(team.draws)
		grid.add_child(draws_label)

		var lost_label: Label = Label.new()
		style_label(lost_label)
		lost_label.text = str(team.lost)
		grid.add_child(lost_label)

		var goals_made_label: Label = Label.new()
		style_label(goals_made_label)
		goals_made_label.text = str(team.goals_made)
		grid.add_child(goals_made_label)

		var goals_against_label: Label = Label.new()
		style_label(goals_against_label)
		goals_against_label.text = str(team.goals_against)
		grid.add_child(goals_against_label)

		var points_label: Label = Label.new()
		style_label(points_label)
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


func style_label(label: Label) -> void:
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.custom_minimum_size = Vector2(60, 0)


func _on_leagues_item_selected(index: int) -> void:
	set_up(Config.leagues.list[index])
