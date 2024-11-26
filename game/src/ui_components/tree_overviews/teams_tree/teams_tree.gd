# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TeamsTree
extends Tree

signal team_selected(team: Team)

var teams: Dictionary
var items: Array[TreeItem]


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	Tests.setup_mock_world(true)
	
	teams = {}
	items = []


func setup(_include_national_teams: bool = false) -> void:
	# world competitons
	var continents_item: TreeItem = _create_item("CONTINENTS")
	# continents
	for continent: Continent in Global.world.continents:
		var continent_item: TreeItem = _create_item(continent.name, continents_item)
		# nations
		for nation: Nation in continent.nations:
			var nation_item: TreeItem = _create_item(nation.name, continent_item)
			# nation leagues
			for league: League in nation.leagues:
				var league_item: TreeItem = _create_item(league.name, nation_item)
				for team: Team in league.teams:
					_create_item(team.name, league_item, team)


func select(team_name: String) -> void:
	deselect_all()
	# set selected item
	for item: TreeItem in items:
		if item.get_text(0) == team_name:
			set_selected(item, 0)
			return


func _create_item(text: String, parent: TreeItem = null, team: Team = null) -> TreeItem:
	var item: TreeItem
	if parent:
		item = parent.create_child()
	else:
		item = create_item()
	item.set_text(0, text)
	items.append(item)

	if team:
		teams[team.name] = team

	return item


func _on_item_mouse_selected(_mouse_position: Vector2, _mouse_button_index: int) -> void:
	var selected_name: String = get_selected().get_text(0)
	if teams.has(selected_name):
		team_selected.emit(teams[selected_name])
		SoundUtil.play_button_sfx()

