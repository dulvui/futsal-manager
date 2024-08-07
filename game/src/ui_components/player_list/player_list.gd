# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerList
extends VBoxContainer

signal select_player(player: Player)

const PlayerListColumnScene = preload("res://src/ui_components/player_list/player_list_column/player_list_column.tscn")

@onready var filter_container: HBoxContainer = $Filters
@onready var team_select: OptionButton = $Filters/TeamSelect
@onready var league_select: OptionButton = $Filters/LeagueSelect
@onready var pos_select: OptionButton = $Filters/PositionSelect
@onready var footer: HBoxContainer = $Footer
@onready var page_indicator: Label = $Footer/PageIndicator
@onready var active_view_option_button: SwitchOptionButton = $Filters/ActiveView

@onready var views_container: HBoxContainer = $Views


var views: Array[String]
var columns: Dictionary = {}
var active_view: String

var active_team_id: int

var sorting: Dictionary = {}
var filters: Dictionary = {}

var all_players: Array[Player] = []
var players: Array[Player] = []
var visible_players: Array[Player] = []

var page:int
var page_max:int
var page_size:int = 16
 

func _ready() -> void:
	team_select.add_item("NO_TEAM")
	for league: League in Config.leagues.list:
		for team: Team in league.teams:
			if team == null or Config.team == null or team.name != Config.team.name:
				team_select.add_item(team.name)

	pos_select.add_item("NO_POS")
	for pos: String in Position.Type.keys():
		pos_select.add_item(pos)

	league_select.add_item("ALL_LEAGUES")
	for league: League in Config.leagues.list:
		league_select.add_item(league.name)

	# setup automatically, if run in editor and is run by 'Run current scene'
	if OS.has_feature("editor") and get_parent() == get_tree().root:
		set_up()

func set_up(p_active_team_id: int = -1) -> void:
	active_team_id = p_active_team_id

	if active_team_id != -1:
		team_select.hide()
		league_select.hide()

	_set_up_players()

	page_max = players.size() / page_size

	_set_up_columns()
	active_view = views[0]
	active_view_option_button.set_up(views)

	_update_page_indicator()
	_show_active_column()


func update_team(p_active_team_id: int) -> void:
	active_team_id = p_active_team_id
	_set_up_players()
	_update_columns()

	_update_page_indicator()
	_show_active_column()



func _set_up_columns() -> void:
	for child in views_container.get_children():
		child.queue_free()

	visible_players = players.slice(page * page_size, (page + 1) * page_size)

	# names
	var names: Callable = func(p: Player) -> String: return p.surname
	_add_column("surname", "surname", names)
	var name_col: PlayerListColumn = columns["surname"]
	name_col.custom_minimum_size.x = 200
	# connect name button  signal
	for i: int in visible_players.size():
		name_col.color_labels[i].enable_button()
		name_col.color_labels[i].button.pressed.connect(func() -> void: select_player.emit(visible_players[i]))

	# separator
	views_container.add_child(VSeparator.new())

	# general
	var team_names: Callable = func(p: Player) -> String: return p.team
	_add_column("general", "team", team_names)
	var nationalities: Callable = func(p: Player) -> String: return Const.Nations.keys()[p.nation]
	_add_column("general", "nation", nationalities)
	var positions: Callable = func(p: Player) -> String: return Position.Type.keys()[p.position.type]
	_add_column("general", "position", positions)
	var prices: Callable = func(p: Player) -> String: return FormatUtil.get_sign(p.price)
	_add_column("general", "price", prices)
	#var birth_dates: Callable = func(p: Player) -> String: return FormatUtil.format_date(p.birth_date)
	var birth_dates: Callable = func(p: Player) -> Dictionary: return p.birth_date
	_add_column("general", "birth_date", birth_dates)
	var presitge_stars: Callable = func(p: Player) -> String: return p.get_prestige_stars()
	_add_column("general", "prestige", presitge_stars)
	var moralities: Callable = func(p: Player) -> int: return p.morality
	_add_column("general", "morality", moralities)

	# contract
	for c: Dictionary in Contract.new().get_property_list():
		if c.usage == 4102:
			var stats: Callable = func(p: Player) -> Variant: return p.contract.get(c.name)
			_add_column("contract", c.name, stats)

	# statistics
	for s: Dictionary in Statistics.new().get_property_list():
		if s.usage == 4102:
			var stats: Callable = func(p: Player) -> Variant: return p.statistics[0].get(s.name)
			_add_column("statistics", s.name, stats)

	# attributes
	for key: String in Const.ATTRIBUTES.keys():
		for value: String in Const.ATTRIBUTES[key]:
			var value_path: Array[String] = ["attributes", key, value]
			var attributes: Callable = func(p: Player) -> int: return p.get_res_value(value_path)
			_add_column(key, value, attributes)


func _update_columns() -> void:
	visible_players = players.slice(page * page_size, (page + 1) * page_size)

	for col: PlayerListColumn in columns.values():
		col.update_values(visible_players)


func _add_column(view_name:String, col_name: String, map_function: Callable) -> void:
	var col: PlayerListColumn = PlayerListColumnScene.instantiate()
	views_container.add_child(col)
	col.set_up(view_name, col_name, visible_players, map_function)
	col.sort.connect(_sort_players.bind(col_name, map_function))
	columns[col_name] = col
	if view_name != "surname" and not view_name in views:
		views.append(view_name)


func _show_active_column() -> void:
	for col: PlayerListColumn in columns.values():
		col.visible = col.view_name == "surname" or col.view_name == active_view


func _set_up_players(p_reset_options: bool = true) -> void:
	if p_reset_options:
		_reset_options()

	all_players = []

	# uncomment to stresstest
	#for i in range(10):
	if active_team_id == -1:
		for league: League in Config.leagues.list:
			for team in league.teams:
				for player in team.players:
					all_players.append(player)
	else:
		for player: Player in Config.leagues.get_team_by_id(active_team_id).players:
			all_players.append(player)

	players = all_players


func _reset_options() -> void:
	league_select.selected = 0
	pos_select.selected = 0
	team_select.selected = 0


func _on_player_profile_select(player: Player) -> void:
	select_player.emit(player)


func _on_next_2_pressed() -> void:
	page += 5
	if page > page_max:
		page = page_max
	_update_page_indicator()
	_update_columns()


func _on_next_pressed() -> void:
	page += 1
	if page > page_max:
		page = 0
	_update_page_indicator()
	_update_columns()


func _on_prev_pressed() -> void:
	page -= 1
	if page < 0:
		page = page_max
	_update_page_indicator()
	_update_columns()


func _on_prev_2_pressed() -> void:
	page -= 5
	if page < 0:
		page = 0
	_update_page_indicator()
	_update_columns()


func _update_page_indicator() -> void:
	page_max = players.size() / page_size
	page_indicator.text = "%d / %d" % [page + 1, page_max + 1]


func _sort_players(value: String, map_function: Callable) -> void:
	var sort_key: String = value
	if sort_key in sorting:
		sorting[sort_key] = not sorting[sort_key]
	else:
		sorting[sort_key] = true

	if "date" in value:
		# dates
		all_players.sort_custom(
			func(a:Player, b:Player) -> bool:
				var a_unix: int = Time.get_unix_time_from_datetime_dict(map_function.call(a))
				var b_unix: int = Time.get_unix_time_from_datetime_dict(map_function.call(b))
				if sorting[sort_key]:
					return a_unix > b_unix
				else:
					return a_unix < b_unix
		)
	else:
		# normal props
		all_players.sort_custom(
			func(a:Player, b:Player) -> bool:
				if sorting[sort_key]:
					return map_function.call(a) > map_function.call(b)
				else:
					return map_function.call(a) < map_function.call(b)
		)

	# after sorting, apply filters
	# so if filters a removed, sort order is kept
	_filter_players(all_players)


func _filter() -> void:
	_filter_players(players)


func _unfilter() -> void:
	_filter_players(all_players)


func _filter_players(player_base: Array[Player]) -> void:
	page = 0

	if filters.size() > 0:
		var filtered_players: Array[Player] = []
		var filter_counter: int = 0
		var value: String
		var key: String

		for player in player_base:
			filter_counter = 0
			for i:int in filters.keys().size():
				key = filters.keys()[i]
				filter_counter += 1
				value = str(filters[key])
				value = value.to_upper()
				if not str(player[key]).to_upper().contains(value):
					filter_counter += 1
			if filter_counter == filters.size():
				filtered_players.append(player)
		players = filtered_players
	else:
		players = all_players

	_update_columns()
	_update_page_indicator()


func _on_name_search_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		if not "surname" in filters:
			filters["surname"] = new_text
			_filter()
		elif new_text.length() > (filters["surname"] as String).length():
			filters["surname"] = new_text
			_filter()
		else:
			filters["surname"] = new_text
			_unfilter()
	else:
		filters.erase("surname")
		_unfilter()


func _on_position_select_item_selected(index: int) -> void:
	if index > 0:
		filters["position"] = Position.Type.values()[index - 1]
		_filter()
	else:
		filters.erase("position")
		_unfilter()


func _on_league_select_item_selected(index: int) -> void:
	if index > 0:
		filters["league"] = league_select.get_item_text(index)
		_filter()
	else:
		filters.erase("league")
		_unfilter()

	# clean team selector
	team_select.clear()
	team_select.add_item("NO_TEAM")

	# adjust team picker according to selected league
	for league: League in Config.leagues.list:
		if not "league" in filters or filters["league"] == league.name:
			for team: Team in league.teams:
				if team == null or team.name != Config.team.name:
					team_select.add_item(team.name)


func _on_team_select_item_selected(index: int) -> void:
	if index > 0:
		filters["team"] = team_select.get_item_text(index)
		_filter()
	else:
		filters.erase("team")
		_unfilter()


func _on_active_view_item_selected(index: int) -> void:
	active_view = views[index]
	_show_active_column()
