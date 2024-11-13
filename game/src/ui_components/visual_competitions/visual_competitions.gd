# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualCompetitions
extends HBoxContainer

const VisualtableScene: PackedScene = preload("res://src/ui_components/visual_competitions/visual_table/visual_table.tscn")

var competition: Competition
var season_index: int
var season_amount: int

@onready var main: VBoxContainer = %Main
@onready var seasons: SwitchOptionButton = %SeasonsButton
@onready var competitions_tree: CompetitionsTree = %CompetitionsTree


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	Tests.setup_mock_world(true)

	# start from last entry
	season_index = Global.league.tables.size() - 1
	season_amount = Global.league.tables.size()

	_set_up_seasons()
	competition = Global.league
	competitions_tree.set_up(competition.name)
	_set_up()


func _set_up() -> void:
	# clean scroll container
	for child: Node in main.get_children():
		child.queue_free()
	
	if competition is League:
		var league: League = (competition as League)
		var table: VisualTable = VisualtableScene.instantiate()
		main.add_child(table)
		table.set_up(league.tables[season_index])
	else:
		var cup: Cup = (competition as Cup)
		if cup.stage == Cup.Stage.GROUP:
			for group: Group in cup.groups:
				# label
				var label: Label = Label.new()
				var index: int = cup.groups.find(group) + 1
				label.text = tr("GROUP") + " " + str(index)
				ThemeUtil.bold(label)
				main.add_child(label)
				# table
				var table: VisualTable = VisualtableScene.instantiate()
				main.add_child(table)
				table.set_up(group.table)
				main.add_child(HSeparator.new())


func _set_up_seasons() -> void:
	var start_year: int = Global.world.calendar.date.year
	var end_year: int = Global.world.calendar.date.year - season_amount

	var season_years: Array[String] = []
	for year: int in range(start_year, end_year, -1):
		season_years.append(str(year))
	seasons.set_up(season_years)


func _on_seasons_button_item_selected(index: int) -> void:
	# substract from season amount,
	# seasons are inserted inverted in options button
	# -1, because arrays start from 0
	season_index = season_amount - 1 - index
	_set_up()

func _on_competitions_tree_competition_selected(p_competition: Competition) -> void:
	competition = p_competition
	_set_up()


func _on_active_button_pressed() -> void:
	competition = Global.league
	competitions_tree.select(competition.name)
	season_index = season_amount - 1
	seasons.option_button.selected = 0
	_set_up()

