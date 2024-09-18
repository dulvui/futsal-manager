# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name World
extends Resource

@export var calendar: Calendar
@export var continents: Array[Continent]
@export var world_cup: CupMixedStage

@export var active_team_id: int


func _init(
	p_calendar: Calendar = Calendar.new(),
	p_continents: Array[Continent] = [],
	p_world_cup: CupMixedStage = CupMixedStage.new(),
	p_active_team_id: int = -1,
) -> void:
	calendar = p_calendar
	continents = p_continents
	world_cup = p_world_cup
	active_team_id = p_active_team_id


func initialize() -> void: 
	calendar.initialize()


func random_results() -> void:
	for c: Continent in Config.world.continents:
		for n: Nation in c.nations:
			n.random_results()


func get_active_team() -> Team:
	return get_team_by_id(active_team_id)


func get_active_league() -> League:
	for l: League in get_all_leagues():
		for t: Team in l.teams:
			if t.id == active_team_id:
				return l
	printerr("no league/team with id " + str(active_team_id))
	return null


func get_team_by_id(team_id: int) -> Team:
	for l: League in get_all_leagues():
		for t: Team in l.teams:
			if t.id == team_id:
				return t
	printerr("no team with id " + str(team_id))
	return null


func get_all_nations() -> Array[Nation]:
	var all_nations: Array[Nation] = []
	for c: Continent in continents:
		all_nations.append_array(c.nations)
	return all_nations


func get_all_leagues() -> Array[League]:
	var leagues: Array[League] = []
	for c: Continent in Config.world.continents:
		for n: Nation in c.nations:
			leagues.append_array(n.leagues)
	return leagues


func get_all_club_cups() -> Array[Competition]:
	var cups: Array[Competition] = []
	for c: Continent in Config.world.continents:
		cups.append(c.cup_clubs)
		for n: Nation in c.nations:
			cups.append(n.cup)
	return cups
