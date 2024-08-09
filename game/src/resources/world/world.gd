# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name World
extends Resource

@export var calendar: Calendar
@export var continents: Array[Continent]
@export var cup_clubs: Tournament
@export var cup_nations: Tournament


func _init(
	p_calendar: Calendar = Calendar.new(),
	p_continents: Array[Continent] = [],
	p_cup_clubs: Tournament = Tournament.new(),
	p_cup_nations: Tournament = Tournament.new(),
) -> void:
	calendar = p_calendar
	continents = p_continents
	cup_clubs = p_cup_clubs
	cup_nations = p_cup_nations


func add_club(continent_name: String, nation_name: String, team_name: String) -> void:
	# setup continent, if not done yet
	var continent: Continent
	var continent_filter: Array[Continent] = continents.filter(func(c: Continent) -> bool: return c.name == continent_name)
	if continent_filter.size() == 0:
		continent = Continent.new()
		continent.name = continent_name
	else:
		continent = continent_filter[0]
	
	# setup nation, if not done yet
	var nation: Nation
	var nation_filter: Array[Nation] = continent.nations.filter(func(n: Nation) -> bool: return n.name == nation_name)
	if nation_filter.size() == 0:
		nation = Nation.new()
		nation.name = nation_name
	else:
		nation = nation_filter[0]
	
	# add team
	var team: Team = Team.new()
	team.name = team_name
	nation.leagues = Leagues.new()
	nation.leagues.list.append(team)
	
	
func get_all_leagues() -> Array[League]:
	var leagues: Array[League] = []
	for c: Continent in Config.world.continents:
		for n: Nation in c.nations:
			leagues.append_array(n.leagues.list)
	return leagues
