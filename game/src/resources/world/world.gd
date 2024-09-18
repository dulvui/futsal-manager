# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name World
extends Resource

const WORLD_CSV_PATH: String = "res://data/world/world.csv"

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
	_init_from_csv()
	calendar = Calendar.new()
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


func _init_from_csv() -> void:
	var file: FileAccess = FileAccess.open(WORLD_CSV_PATH, FileAccess.READ)
	
	# get header row
	# CONTINENT, NATION, CITY, POPULATION
	var header_line: PackedStringArray = file.get_csv_line()
	var headers: Array[String] = []
	# transform to array and make lower case
	for header: String in header_line:
		headers.append(header.to_lower())
	
	while not file.eof_reached():
		var line: PackedStringArray = file.get_csv_line()
		if line.size() > 1:
			var continent: String = line[0]
			var nation: String = line[1]
			var league: String = line[2]
			var city: String = line[3]
			_initialize_city(continent, nation,league, city)


func _initialize_city(continent_name: String, nation_name: String, league_name: String, team_name: String) -> void:
	# setup continent, if not done yet
	var continent: Continent
	var continent_filter: Array[Continent] = continents.filter(func(c: Continent) -> bool: return c.name == continent_name)
	if continent_filter.size() == 0:
		continent = Continent.new()
		continent.name = continent_name
		continents.append(continent)
		# TODO create competition history here
	else:
		continent = continent_filter[0]
	
	# setup nation, if not done yet
	var nation: Nation
	var nation_filter: Array[Nation] = continent.nations.filter(func(n: Nation) -> bool: return n.name == nation_name)
	if nation_filter.size() == 0:
		nation = Nation.new()
		nation.name = nation_name
		continent.nations.append(nation)
	else:
		nation = nation_filter[0]
	
	# setup league, if note done yet or last league is full
	var league: League
	var league_filter: Array[League] = nation.leagues.filter(func(l: League) -> bool: return l.name == league_name)
	if league_filter.size() == 0:
		league = League.new()
		league.name = league_name
		# could bea added direclty to csv
		# with this code, leagues/teams need to be in pyramid level order
		league.pyramid_level = nation.leagues.size() + 1
		nation.leagues.append(league)
	else:
		league = league_filter[0]
	
	# add team
	var team: Team = Team.new()
	team.name = team_name
	league.add_team(team)
