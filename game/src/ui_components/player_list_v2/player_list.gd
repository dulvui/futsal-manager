# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerList
extends VBoxContainer


signal select_player(player: Player)

const PAGE_SIZE:int = 20

@onready var player_rows: VBoxContainer = $PlayerRows
@onready var team_select: OptionButton = $Filters/TeamSelect
@onready var league_select: OptionButton = $Filters/LeagueSelect
@onready var pos_select: OptionButton = $Filters/PositionSelect
@onready var footer: HBoxContainer = $Footer
@onready var page_indicator: Label = $Footer/PageIndicator

var filters: Dictionary = {}
var active_info_type: int = 0
var team_search: String = ""

var all_players: Array[Player] = []
var players: Array[Player] = []
var visible_players: Array[Player] = []

var page:int
var page_max:int


func _ready() -> void:
	team_select.add_item("NO_TEAM")
	for league: League in Config.leagues.list:
		for team: Team in league.teams:
			if team == null or team.name != Config.team.name:
				team_select.add_item(team.name)

	pos_select.add_item("NO_POS")
	for pos: String in Player.Position.keys():
		pos_select.add_item(pos)

	league_select.add_item("ALL_LEAGUES")
	for league: League in Config.leagues.list:
		league_select.add_item(league.name)
	
	_set_up_all_players()

	page_max = players.size() / PAGE_SIZE

	_set_player_rows()
	_update_page_indicator()
	

func _set_player_rows() -> void:
	visible_players = players.slice(page * PAGE_SIZE, (page + 1) * PAGE_SIZE)
	
	var index: int = 0
	for player_row: PlayerListRow in player_rows.get_children() as Array[PlayerListRow]:
		if index < visible_players.size():
			player_row.visible = true
			player_row.set_player(visible_players[index])
		else:
			player_row.visible = false
		index += 1


func _set_up_all_players(p_reset_options: bool = true) -> void:
	if p_reset_options:
		_reset_options()

	all_players = []
	for league: League in Config.leagues.list:
		for team in league.teams:
			for player in team.players:
				all_players.append(player)
	
	players = all_players


func _remove_player(player_id: int) -> void:
	filters["id"] = player_id
	_filter_players()


func _on_NameSearch_text_changed(text: String) -> void:
	if text.length() > 2:
		filters["surname"] = text
		_filter_players()
	elif "surname" in filters and (filters["surname"] as String).length() > 0:
		filters["surname"] = ""
		_filter_players()


func _on_TeamSelect_item_selected(index: int) -> void:
	if index > 0:
		filters["team"] = team_select.get_item_text(index)
	else:
		filters["team"] = ""
	_filter_players()


func _on_league_select_item_selected(index: int) -> void:
	if index > 0:
		filters["league"] = league_select.get_item_text(index)
	else:
		filters["league"] = ""

	# clean team selector
	team_select.clear()
	team_select.add_item("NO_TEAM")

	# adjust team picker according to selected league
	for league: League in Config.leagues.list:
		if filters["league"] == "" or filters["league"] == league.name:
			for team: Team in league.teams:
				if team == null or team.name != Config.team.name:
					team_select.add_item(team.name)

	_filter_players()


func _on_PositionSelect_item_selected(index: int) -> void:
	if index > 0:
		filters["position"] = Player.Position.values()[index - 1]
	else:
		filters["position"] = ""

	_filter_players()


func _reset_options() -> void:
	league_select.selected = 0
	pos_select.selected = 0
	team_select.selected = 0
	active_info_type = 0


func _on_player_profile_select(player: Player) -> void:
	select_player.emit(player)


func _on_next_2_pressed() -> void:
	page += 5
	if page > page_max:
		page = page_max
	_update_page_indicator()
	_set_player_rows()


func _on_next_pressed() -> void:
	page += 1
	if page > page_max:
		page = 0
	_update_page_indicator()
	_set_player_rows()


func _on_prev_pressed() -> void:
	page -= 1
	if page < 0:
		page = page_max
	_update_page_indicator()
	_set_player_rows()


func _on_prev_2_pressed() -> void:
	page -= 5
	if page < 0:
		page = 0
	_update_page_indicator()
	_set_player_rows()


func _update_page_indicator() -> void:
	page_max = players.size() / PAGE_SIZE
	page_indicator.text = "%d / %d" % [page + 1, page_max + 1]


func _on_name_search_text_changed(new_text: String) -> void:
	if new_text.length() > 2:
		filters["surname"] = new_text
	else:
		filters.erase("surname")
	_filter_players()


func _filter_players() -> void:
	if filters.size() > 0:
		page = 0
		visible_players = []
		var filtered_players: Array[Player] = []
		for player in players:
			print(player.surname)
			var filter_counter: int = 0
			for key: String in filters.keys():
				filter_counter += 1
				var value: String = filters[key] as String
				if not value.to_upper() in (player[key] as String).to_upper():
					filter_counter += 1
			if filter_counter == filters.size():
				filtered_players.append(player)
		players = filtered_players
	else:
		players = all_players

	_set_player_rows()
	_update_page_indicator()
	
