# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Team

@export var id:String
@export var name:String
@export var lineup_player_ids:Array[int]
@export var lineup_sub_ids:Array[int]
@export var formation:Formation
@export var prestige:int
@export var budget:int
@export var salary_budget:int
@export var players:Array[Player]
@export var stadium:Stadium
# shirt colors
# 0: home color, 1: away, 2 third color
@export var colors:Array[Color]

func _init(
	p_name:String = "",
	p_id:String = "",
	p_prestige:int = 0,
	p_budget:int = 0,
	p_salary_budget:int = 0,
	p_players:Array[Player] = [],
	p_formation:Formation = Formation.new(),
	p_lineup_player_ids:Array[int] = [],
	p_lineup_sub_ids:Array[int] = [],
	p_stadium:Stadium = Stadium.new(),
	p_colors:Array[Color] = [Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0)],
) -> void:
	id = p_id
	name = p_name
	prestige = p_prestige
	budget = p_budget
	salary_budget = p_salary_budget
	players = p_players
	stadium = p_stadium
	colors = p_colors
	formation = p_formation
	lineup_player_ids = p_lineup_player_ids
	lineup_sub_ids = p_lineup_sub_ids

func create_stadium(_name:String, capacity:int, year_built:int) -> void:
	stadium = Stadium.new()
	stadium.name = _name
	stadium.capacity = capacity
	stadium.year_built = year_built

func get_goalkeeper() -> Player:
	for player in players:
		if player.id == lineup_player_ids[0]:
			return player
	return null

func get_lineup_players(include_goalkeeper:bool=false) -> Array[Player]:
	var lineup:Array[Player] = []
	for player in players:
		if player.id in lineup_player_ids:
			lineup.append(player)
	if not include_goalkeeper:
		lineup.pop_front()
	return lineup

func get_lineup_player(index:int) -> Player:
	for player in players:
		if player.id == lineup_player_ids[index]:
			return player
	return null
	
func get_sub_players() -> Array[Player]:
	var sub:Array[Player] = []
	for player in players:
		if player.id in lineup_sub_ids:
			sub.append(player)
	return sub
	
func is_lineup_player(player:Player) -> bool:
	return player.id in lineup_player_ids
	
func is_sub_player(player:Player) -> bool:
	return player.id in lineup_sub_ids
