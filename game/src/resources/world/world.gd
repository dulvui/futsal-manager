# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name World
extends Resource

const WORLD_CSV_PATH: String = "res://data/world/world.csv"

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


func initialize() -> void: 
	init_from_csv()
	calendar = Calendar.new()
	calendar.initialize()


func init_from_csv() -> void:
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
			var city: String = line[2]
			#var population: int = int(line[3])
			add_club(continent, nation, city)


func add_club(continent_name: String, nation_name: String, team_name: String) -> void:
	# setup continent, if not done yet
	var continent: Continent
	var continent_filter: Array[Continent] = continents.filter(func(c: Continent) -> bool: return c.name == continent_name)
	if continent_filter.size() == 0:
		continent = Continent.new()
		continent.name = continent_name
		continents.append(continent)
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
	if nation.leagues.size() == 0 or nation.leagues[-1].teams.size() == 10:
		league = League.new()
		# TODO better league names
		league.name = nation.name + " " + str(league.id)
		league.pyramid_level = 1
		nation.leagues.append(league)
	else:
		league = nation.leagues[-1]
	
	# add team
	var team: Team = Team.new()
	team.name = team_name
	league.add_team(team)



func initialize_calendars() -> void:
	# TODO initialize all calendars
	pass


func random_results() -> void:
	for c: Continent in Config.world.continents:
		for n: Nation in c.nations:
			n.random_results()


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
