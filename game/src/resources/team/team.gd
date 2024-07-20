# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Team
extends Resource

@export var id: int
@export var name: String
# 0 to 4 active, 5 to x subs
@export var lineup_player_ids: Array[int]
@export var formation: Formation
@export var budget: int
@export var salary_budget: int
@export var players: Array[Player]

@export var staff: Staff
@export var stadium: Stadium
@export var board_requests: BoardRequests
# shirt colors
# 0: home color, 1: away, 2 third color
@export var colors: Array[Color]


func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.TEAM),
	p_name: String = "",
	p_budget: int = 0,
	p_salary_budget: int = 0,
	p_players: Array[Player] = [
		Player.new(1),
		Player.new(2),
		Player.new(3),
		Player.new(4),
		Player.new(5)
	],
	p_formation: Formation = Formation.new(),
	p_lineup_player_ids: Array[int] = [1, 2, 3, 4, 5],
	p_staff: Staff = Staff.new(),
	p_stadium: Stadium = Stadium.new(),
	p_board_requests: BoardRequests = BoardRequests.new(),
	p_colors: Array[Color] = [Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0)],
) -> void:
	id = p_id
	name = p_name
	budget = p_budget
	salary_budget = p_salary_budget
	players = p_players
	staff = p_staff
	stadium = p_stadium
	colors = p_colors
	formation = p_formation
	board_requests = p_board_requests
	lineup_player_ids = p_lineup_player_ids


func create_stadium(_name: String, capacity: int, year_built: int) -> void:
	stadium = Stadium.new()
	stadium.name = _name
	stadium.capacity = capacity
	stadium.year_built = year_built


func get_goalkeeper() -> Player:
	for player in players:
		if player.id == lineup_player_ids[0]:
			return player
	return null


func get_non_lineup_players() -> Array[Player]:
	var non_lineup: Array[Player] = []
	for player in players:
		if player.id not in lineup_player_ids:
			non_lineup.append(player)
	return non_lineup


# get lineup players with goalkeeper
func get_lineup_players() -> Array[Player]:
	var lineup: Array[Player] = []
	for player in players:
		if player.id in lineup_player_ids.slice(0, 5):
			lineup.append(player)
	return lineup


# get lineup players without goalkeeper
func get_field_players() -> Array[Player]:
	var field_players: Array[Player] = []
	for player in players:
		if player.id in lineup_player_ids.slice(1, 5):
			field_players.append(player)
	return field_players


func get_sub_players() -> Array[Player]:
	var sub: Array[Player] = []
	for player in players:
		if player.id in lineup_player_ids.slice(5, Const.LINEUP_PLAYERS_AMOUNT):
			sub.append(player)
	return sub


func get_lineup_player(index: int) -> Player:
	for player in players:
		if player.id == lineup_player_ids[index]:
			return player
	return null


func is_lineup_player(player: Player) -> bool:
	var index: int = lineup_player_ids.find(player.id)
	return index >= 0 and index <= 4


func is_sub_player(player: Player) -> bool:
	var index: int = lineup_player_ids.find(player.id)
	return index > 4 and index < Const.LINEUP_PLAYERS_AMOUNT


func change_players(player_id1: int, player_id2: int) -> void:
	if player_id1 in lineup_player_ids and player_id2 in lineup_player_ids:
		var index1: int = lineup_player_ids.find(player_id1)
		var index2: int = lineup_player_ids.find(player_id2)
		lineup_player_ids[index1] = player_id2
		lineup_player_ids[index2] = player_id1
	elif player_id1 in lineup_player_ids:
		var index1: int = lineup_player_ids.find(player_id1)
		lineup_player_ids[index1] = player_id2
	elif player_id2 in lineup_player_ids:
		var index2: int = lineup_player_ids.find(player_id2)
		lineup_player_ids[index2] = player_id1


func remove_player(p_player: Player) -> void:
	players.erase(p_player)
	for l_id: int in lineup_player_ids:
		if l_id == p_player.id:
			# TODO choose player for same position
			lineup_player_ids.erase(l_id)
			lineup_player_ids.append(players[-1].id)
			break


func get_home_color() -> Color:
	return colors[0]


func get_away_color(versus_color: Color) -> Color:
	if colors[1] != versus_color:
		return colors[1]
	if colors[2] != versus_color:
		return colors[2]
	return colors[0]


func get_prestige() -> int:
	var value: int = 0
	for player: Player in players:
		value += player.get_overall()
	return value / players.size()


func get_prestige_stars() -> String:
	var relation: int = Const.MAX_PRESTIGE / 4
	var star_factor: int = Const.MAX_PRESTIGE / relation
	var stars: int = max(1, get_prestige() / star_factor)
	var spaces: int = 5 - stars
	# creates right padding ex: "***  "
	return "*".repeat(stars) + "  ".repeat(spaces)
