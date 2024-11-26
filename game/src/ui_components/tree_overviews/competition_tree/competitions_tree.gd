# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CompetitionsTree
extends Tree

signal competition_selected(competition: Competition)

# [competition name][TreeItem]
var competitions: Dictionary
var items: Array[TreeItem]


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	Tests.setup_mock_world(true)
	
	competitions = {}
	items = []


func setup(competition_name: String = "") -> void:
	# world competitons
	var world_item: TreeItem = _create_item("WORLD")
	_create_item("WORLD CUP", world_item, Global.world.world_cup)
	var continents_item: TreeItem = _create_item("CONTINENTS", world_item)
	# continents
	for continent: Continent in Global.world.continents:
		var continent_item: TreeItem = _create_item(continent.name, continents_item)
		# nations
		for nation: Nation in continent.nations:
			var nation_item: TreeItem = _create_item(nation.name, continent_item)
			# nation leagues
			for league: League in nation.leagues:
				_create_item(league.name, nation_item, league)
			# nation cups
			_create_item(nation.cup.name, nation_item, nation.cup)
		# continental cups
		_create_item(continent.cup_clubs.name, continent_item, continent.cup_clubs)
		_create_item(continent.cup_nations.name, continent_item, continent.cup_nations)
	
	select(competition_name)


func select(competition_name: String) -> void:
	deselect_all()
	# set selected item
	for item: TreeItem in items:
		if item.get_text(0) == competition_name:
			set_selected(item, 0)
			return


func _create_item(text: String, parent: TreeItem = null, competition: Competition = null) -> TreeItem:
	var item: TreeItem
	if parent:
		item = parent.create_child()
	else:
		item = create_item()
	item.set_text(0, text)
	items.append(item)

	if competition:
		competitions[competition.name] = competition

	return item


func _on_item_mouse_selected(_mouse_position: Vector2, _mouse_button_index: int) -> void:
	var selected_name: String = get_selected().get_text(0)
	if competitions.has(selected_name):
		competition_selected.emit(competitions[selected_name])
		SoundUtil.play_button_sfx()

