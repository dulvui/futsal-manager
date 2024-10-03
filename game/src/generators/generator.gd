# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name Generator
extends Node

const WORLD_CSV_PATH: String = "res://data/world/world.csv"
const NAMES_DIR: String = "res://data/player_names/"
const LEAGUES_DIR: String = "res://data/leagues/"

# defines noise added to attribute factors
const NOISE: int = 3

# defines year, when history starts
const HISTORY_YEARS: int = 10

var leagues_data: Dictionary = {}
var names: Dictionary = {}

# for birthdays range
var date: Dictionary
var max_timestamp: int
var min_timestamp: int
var world: World


func generate_world() -> World:
	_generate_world_from_csv()

	# generate players
	_load_person_names()
	for c: Continent in world.continents:
		for n: Nation in c.nations:
			for l: League in n.leagues:
				for t: Team in l.teams:
					_initialize_team(n, l, t)
	
	# first generate clubs history with promotions, delegations, cup wins
	_generate_club_history()
	# then generate player histroy with trasnfers and statistics
	_generate_player_history()

	return world


func _initialize_team(nation: Nation, league: League, team: Team) -> void:
	# create date ranges
	# starts from current year and subtracts min/max years
	# youngest player can be 15 and oldest 45
	date = Config.save_states.temp_state.start_date

	var temp_team_prestige: int = _get_team_prestige(league.pyramid_level)

	var max_date: Dictionary = date.duplicate()
	max_date.month = 1
	max_date.day = 1
	max_date.year -= 15
	max_timestamp = Time.get_unix_time_from_datetime_dict(max_date)
	max_date.year -= 30
	min_timestamp = Time.get_unix_time_from_datetime_dict(max_date)

	# create team
	team.colors = []
	team.colors.append(
		Color(
			RngUtil.rng.randf_range(0, 1),
			RngUtil.rng.randf_range(0, 1),
			RngUtil.rng.randf_range(0, 1)
		)
	)
	team.colors.append(team.colors[0].inverted())
	team.colors.append(
		Color(
			RngUtil.rng.randf_range(0, 1),
			RngUtil.rng.randf_range(0, 1),
			RngUtil.rng.randf_range(0, 1)
		)
	)

	team.create_stadium(team.name + " Stadium", 1234, 1990)

	_assign_players_to_team(team, league, nation, temp_team_prestige)

	team.staff = _create_staff(team.get_prestige(), nation, league.pyramid_level)
	
	# assign manager preffered formation to team
	team.formation = team.staff.manager.formation

	# calc budget, after players/stuff have been created
	# so budget will alwyas be bigger as minimum needed
	team.budget = _get_budget(temp_team_prestige)
	team.salary_budget = _get_salary_budget(team.players, team.staff, temp_team_prestige)


func _assign_players_to_team(p_team: Team, p_league: League, p_nation: Nation, prestige: int) -> Team:
	var nr: int = 1

	for position_type: int in Position.Type.values():
		var amount: int = RngUtil.rng.randi_range(2, 5)
		if position_type == Position.Type.G:
			amount = 3

		for i in amount:
			var random_nation: Nation = _get_random_nationality(
				p_nation, prestige, p_league.pyramid_level
			)
			var player: Player = _create_player(random_nation, nr, prestige, position_type)
			nr += 1
			player.team = p_team.name
			player.team_id = p_team.id
			player.league = p_league.name
			p_team.players.append(player)

			# RngUtil.rng.random lineup assignment
			if position_type == Position.Type.G and p_team.lineup_player_ids.is_empty():
				p_team.lineup_player_ids.append(player.id)
			elif (
				position_type != Position.Type.G
				and p_team.lineup_player_ids.size() < Const.LINEUP_PLAYERS_AMOUNT
			):
				p_team.lineup_player_ids.append(player.id)

	return p_team


func _get_goalkeeper_attributes(age: int, prestige: int, position: Position) -> Goalkeeper:
	var attributes: Goalkeeper = Goalkeeper.new()

	var age_factor: int = _get_age_factor(age)
	var factor: int = _in_bounds_random(prestige + age_factor)

	# goalkeepers have max potential of 20
	var max_potential: int = _in_bounds_random(factor)

	# non-goalkeepers have max potential of 10, since they could play as goalkeeper in a 4 + 1 field player situation
	if position.type != Position.Type.G:
		max_potential /= 2

	attributes.reflexes = _in_bounds_random(factor, max_potential)
	attributes.positioning = _in_bounds_random(factor, max_potential)
	attributes.kicking = _in_bounds_random(factor, max_potential)
	attributes.handling = _in_bounds_random(factor, max_potential)
	attributes.diving = _in_bounds_random(factor, max_potential)
	attributes.speed = _in_bounds_random(factor, max_potential)
	return attributes


func _get_physical(age: int, prestige: int, position: Position) -> Physical:
	var attributes: Physical = Physical.new()

	var age_factor: int = _get_physical_age_factor(age)

	var pace_factor: int = _in_bounds_random(prestige + age_factor)
	var physical_factor: int = _in_bounds_random(prestige + age_factor)

	# non goalkeepers have max potential
	var max_potential: int = _in_bounds_random(prestige)

	# goalkeepers have max potential of 10, since they could play as goalkeeper in a 4 + 1 field player situation
	if position.type == Position.Type.G:
		max_potential /= 2

	attributes.pace = _in_bounds_random(pace_factor, max_potential)
	attributes.acceleration = _in_bounds_random(pace_factor, max_potential)
	attributes.stamina = _in_bounds_random(physical_factor, max_potential)
	attributes.strength = _in_bounds_random(physical_factor, max_potential)
	attributes.agility = _in_bounds_random(physical_factor, max_potential)
	attributes.jump = _in_bounds_random(physical_factor, max_potential)

	return attributes


func _get_technical(age: int, prestige: int, position: Position) -> Technical:
	var attributes: Technical = Technical.new()

	var age_factor: int = _get_age_factor(age)

	# use also pos i calculation
	var pass_factor: int = _in_bounds_random(prestige + age_factor)
	var shoot_factor: int = _in_bounds_random(prestige + age_factor)
	var technique_factor: int = _in_bounds_random(prestige + age_factor)
	var defense_factor: int = _in_bounds_random(prestige + age_factor)

	# non goalkeepers have max potential
	var max_potential: int = _in_bounds_random(prestige)

	# goalkeepers have max potential of 10, since they could play as goalkeeper in a 4 + 1 field player situation
	if position.type == Position.Type.G:
		max_potential /= 2

	attributes.crossing = _in_bounds_random(pass_factor, max_potential)
	attributes.passing = _in_bounds_random(pass_factor, max_potential)
	attributes.long_passing = _in_bounds_random(pass_factor, max_potential)
	attributes.tackling = _in_bounds_random(defense_factor, max_potential)
	attributes.heading = _in_bounds_random(shoot_factor, max_potential)
	attributes.interception = _in_bounds_random(defense_factor, max_potential)
	attributes.shooting = _in_bounds_random(shoot_factor, max_potential)
	attributes.long_shooting = _in_bounds_random(shoot_factor, max_potential)
	attributes.penalty = _in_bounds_random(technique_factor, max_potential)
	attributes.finishing = _in_bounds_random(shoot_factor, max_potential)
	attributes.dribbling = _in_bounds_random(shoot_factor, max_potential)
	attributes.blocking = _in_bounds_random(shoot_factor, max_potential)
	return attributes


func _get_mental(age: int, prestige: int) -> Mental:
	var attribtues: Mental = Mental.new()

	var age_factor: int = _get_age_factor(age)

	var offensive_factor: int = _in_bounds_random(prestige + age_factor)
	var defensive_factor: int = _in_bounds_random(prestige + age_factor)

	var max_potential: int = _in_bounds_random(prestige)

	attribtues.aggression = _in_bounds_random(defensive_factor, max_potential)
	attribtues.anticipation = _in_bounds_random(defensive_factor, max_potential)
	attribtues.marking = _in_bounds_random(defensive_factor, max_potential)

	attribtues.decisions = _in_bounds_random(offensive_factor, max_potential)
	attribtues.concentration = _in_bounds_random(offensive_factor, max_potential)
	attribtues.teamwork = _in_bounds_random(offensive_factor, max_potential)
	attribtues.vision = _in_bounds_random(offensive_factor, max_potential)
	attribtues.work_rate = _in_bounds_random(offensive_factor, max_potential)
	attribtues.offensive_movement = _in_bounds_random(offensive_factor, max_potential)

	return attribtues


func _get_physical_age_factor(age: int) -> int:
	# for  24 +- _noise <  age factor is negative
	if age < 24 + _noise():
		return RngUtil.rng.randi_range(-5, 3)
	return RngUtil.rng.randi_range(1, 7)


func _get_age_factor(age: int) -> int:
	# for  34 +- _noise < age < 18 +- _noise age factor is negative
	if age > 34 + _noise() or age < 18 + _noise():
		return RngUtil.rng.randi_range(-5, 1)
	# else age factor is positive
	return RngUtil.rng.randi_range(-1, 5)


func _get_price(age: int, prestige: int, position: Position) -> int:
	var age_factor: int = max(min(abs(age - 30), 20), 1)
	var pos_factor: int = 0
	if position.type == Position.Type.G:
		pos_factor = 5
	elif position.type == Position.Type.DC || position.type == Position.Type.DR || position.type == Position.Type.DL:
		pos_factor = 10
	elif position.type == Position.Type.WL || position.type == Position.Type.WR:
		pos_factor = 15
	else:
		pos_factor = 20

	var total_factor: int = age_factor + pos_factor + prestige

	return RngUtil.rng.randi_range(max(total_factor - 20, 0), total_factor) * 1000


func _get_random_foot() -> Player.Foot:
	if RngUtil.rng.randi() % 5 == 0:
		return Player.Foot.L
	return Player.Foot.R


func _get_random_form() -> Player.Form:
	var factor: int = RngUtil.rng.randi() % 100
	if factor < 5:
		return Player.Form.Injured
	elif factor < 15:
		return Player.Form.Recover
	elif factor < 60:
		return Player.Form.Good
	return Player.Form.Excellent


func _get_random_morality() -> Player.Morality:
	var factor: int = RngUtil.rng.randi() % 100
	if factor < 5:
		return Player.Morality.Horrible
	elif factor < 15:
		return Player.Morality.Bad
	elif factor < 60:
		return Player.Morality.Good
	return Player.Morality.Excellent


func _get_contract(person: Person) -> Contract:
	var contract: Contract = Contract.new()
	contract.income = person.prestige * person.get_age()  # TODO use better logic
	contract.start_date = date
	contract.end_date = date
	contract.bonus_goal = 0
	contract.bonus_clean_sheet = 0
	contract.bonus_assist = 0
	contract.bonus_league_title = 0
	contract.bonus_nat_cup_title = 0
	contract.bonus_inter_cup_title = 0
	contract.buy_clause = 0
	contract.is_on_loan = false
	return contract


func _get_person_name(nation: Nation) -> String:
	# TODO randomly use names from other nations, with low probability
	var nation_string: String = nation.name.to_lower()

	if Config.generation_gender == Const.Gender.MALE:
		var size: int = (names[nation_string]["first_names_male"] as Array).size()
		return names[nation_string]["first_names_male"][RngUtil.rng.randi() % size]
	elif Config.generation_gender == Const.Gender.FEMALE:
		var size: int = (names[nation_string]["first_names_female"] as Array).size()
		return names[nation_string]["first_names_female"][RngUtil.rng.randi() % size]
	else:
		var size_female: int = (names[nation_string]["first_names_female"] as Array).size()
		var size_male: int = (names[nation_string]["first_names_male"] as Array).size()
		var female_names: Array = names[nation_string]["first_names_female"]
		var male_names: Array = names[nation_string]["first_names_male"]

		var mixed_names: Array = []
		mixed_names.append_array(female_names)
		mixed_names.append_array(male_names)

		return mixed_names[RngUtil.rng.randi() % (size_female + size_male)]


func _get_person_surname(nation: Nation) -> String:
	# TODO bigger proability for neighbour nations (needs data)

	# 10% change of having random nation's surname
	var different_nation_factor: int = RngUtil.rng.randi() % 100
	if different_nation_factor > 90:
		nation = RngUtil.pick_random(world.get_all_nations())

	var nation_string: String = nation.name.to_lower()

	var size: int = (names[nation_string]["last_names"] as Array).size()
	return names[nation_string]["last_names"][RngUtil.rng.randi() % size]


func  _create_staff(team_prestige: int, team_nation: Nation, pyramid_level: int) -> Staff:
	var staff: Staff = Staff.new()
	staff.manager = _create_manager(team_prestige, team_nation, pyramid_level)
	staff.president = _create_president(team_prestige, team_nation, pyramid_level)
	staff.scout = _create_scout(team_prestige, team_nation, pyramid_level)
	return staff


func _create_manager(team_prestige: int, team_nation: Nation, pyramid_level: int) -> Manager:
	var manager: Manager = Manager.new()
	manager.prestige = _in_bounds_random(team_prestige)
	var nation: Nation = _get_random_nationality(team_nation, team_prestige, pyramid_level)
	manager.nation = nation.name
	manager.name = _get_person_name(nation)
	manager.surname = _get_person_surname(nation)

	manager.contract = _get_contract(manager)
	
	# create random preferred tactics
	manager.formation.set_variation(RngUtil.pick_random(Formation.Variations.values()))
	manager.formation.tactic_offense.intensity = RngUtil.rng.randf()
	manager.formation.tactic_offense.tactic = RngUtil.pick_random(TacticOffense.Tactics.values())
	manager.formation.tactic_defense.marking = RngUtil.pick_random(TacticDefense.Marking.values())
	manager.formation.tactic_defense.pressing = RngUtil.pick_random(TacticDefense.Pressing.values())

	return manager


func _create_president(team_prestige: int, team_nation: Nation, pyramid_level: int) -> President:
	var president: President = President.new()
	president.prestige = _in_bounds_random(team_prestige)
	var nation: Nation = _get_random_nationality(team_nation, team_prestige, pyramid_level)
	president.nation = nation.name
	president.name = _get_person_name(nation)
	president.surname = _get_person_surname(nation)
	president.contract = _get_contract(president)
	return president


func _create_scout(team_prestige: int, team_nation: Nation, pyramid_level: int) -> Scout:
	var scout: Scout = Scout.new()
	scout.prestige = _in_bounds_random(team_prestige)
	var nation: Nation = _get_random_nationality(team_nation, team_prestige, pyramid_level)
	scout.nation = nation.name
	scout.name = _get_person_name(nation)
	scout.surname = _get_person_surname(nation)
	scout.contract = _get_contract(scout)
	return scout


func _create_player(
	nation: Nation, nr: int, p_prestige: int, p_position_type: Position.Type
) -> Player:
	var player: Player = Player.new()
	_random_positions(player, p_position_type)

	# RngUtil.rng.random date from 1970 to 2007
	var birth_date: Dictionary = Time.get_datetime_dict_from_unix_time(
		RngUtil.rng.randi_range(0, max_timestamp)
	)

	var prestige: int = _get_player_prestige(p_prestige)

	player.price = _get_price(date.year - birth_date.year, prestige, player.position)
	player.name = _get_person_name(nation)
	player.surname = _get_person_surname(nation)
	player.birth_date = birth_date
	player.nation = nation.name
	player.foot = _get_random_foot()
	player.morality = _get_random_morality()
	player.form = _get_random_form()
	player.prestige = prestige
	player.injury_factor = RngUtil.rng.randi_range(1, 20)
	player.loyality = RngUtil.rng.randi_range(1, 20)  # if player is loyal, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
	player.contract = _get_contract(player)
	player.nr = nr

	player.attributes = Attributes.new()
	player.attributes.goalkeeper = _get_goalkeeper_attributes(
		date.year - birth_date.year, prestige, player.position
	)
	player.attributes.mental = _get_mental(date.year - birth_date.year, prestige)
	player.attributes.technical = _get_technical(date.year - birth_date.year, prestige, player.position)
	player.attributes.physical = _get_physical(date.year - birth_date.year, prestige, player.position)

	var statistics: Statistics = Statistics.new()
	statistics.team_name = "Test"
	statistics.games_played = 0
	statistics.goals = 0
	statistics.assists = 0
	statistics.yellow_card = 0
	statistics.red_card = 0
	statistics.average_vote = 0
	player.statistics = statistics
	# TODO create history

	return player

func _random_positions(player: Player, p_position_type: Position.Type) -> void:
	# assign main positions
	var position: Position = Position.new()
	position.type = p_position_type
	position.random_variations()
	player.position = position

	# TODO should goalkeeper have alt positions?
	# TODO adapt to make alteratinos more cohereant
	#      to attributes, like defender should have good defense stats
	var alt_positions: Array[Position] = []
	var alt_positions_keys: Array[Variant] = Position.Type.values()
	RngUtil.shuffle(alt_positions_keys)

	for i: int in RngUtil.rng.randi_range(0, alt_positions_keys.size()):
		var alt_position: Position = Position.new()
		alt_position.type = alt_positions_keys[i]
		alt_position.random_variations()
		alt_positions.append(alt_position)

	player.alt_positions = alt_positions


func _get_player_prestige(team_prestige: int) -> int:
	# player prestige is teams prestige +- 5
	return _in_bounds_random(team_prestige)


func _get_team_prestige(pyramid_level: int) -> int:
	var minp: int = Const.MAX_PRESTIGE - pyramid_level * ((RngUtil.rng.randi() % 5) + 1)
	var maxp: int = Const.MAX_PRESTIGE - ((pyramid_level - 1) * 3)
	return _in_bounds(RngUtil.rng.randi_range(minp, maxp))


func _get_random_nationality(
	nation: Nation, prestige: int, pyramid_level: int
) -> Nation:
	# (100 - prestige)% given nation, prestige% random nation
	# with prestige, lower division teams have less players from other nations
	if RngUtil.rng.randi_range(1, 100) > 100 - (prestige * 2 / pyramid_level):
		return world.get_all_nations()[RngUtil.rng.randi_range(0, world.get_all_nations().size() - 1)]
	return nation


func _noise(factor: int = NOISE) -> int:
	return RngUtil.rng.randi_range(-factor, factor)


func _abs_noise(factor: int = NOISE) -> int:
	return RngUtil.rng.randi_range(0, factor)


func _in_bounds_random(value: int, max_bound: int = Const.MAX_PRESTIGE) -> int:
	var random_value: int = value + _noise()
	return _in_bounds(random_value, max_bound)


# returns value between 1 and 20
func _in_bounds(value: int, max_bound: int = Const.MAX_PRESTIGE) -> int:
	return maxi(mini(value, max_bound), 1)


func _load_person_names() -> void:
	for nation: Nation in world.get_all_nations():
		var names_file: FileAccess = FileAccess.open(
			NAMES_DIR + nation.name.to_lower() + ".json", FileAccess.READ
		)
		names[nation.name.to_lower()] = JSON.parse_string(names_file.get_as_text())


func _get_budget(prestige: int) -> int:
	return RngUtil.rng.randi_range(prestige * 10000, prestige * 100000)


func _get_salary_budget(players: Array[Player], staff: Staff, prestige: int) -> int:
	var salary_budget: int = 0

	# sum up all players salary
	for player: Player in players:
		salary_budget += player.get_salary()

	# sum up staff salary
	salary_budget += staff.manager.get_salary()
	salary_budget += staff.scout.get_salary()
	salary_budget += staff.president.get_salary()

	# add random increase
	salary_budget += RngUtil.rng.randi_range(prestige * 1000, prestige * 10000)

	return salary_budget


func _generate_club_history() -> void:
	var current_year: int = date.year
	# TODO world cup history (once national teams exist)
	# TODO continental national teams cup

	# first calculate league tables from starting year back
	# use league tables to define who played in cups
	for contient: Continent in world.continents:
		var continental_cup_teams: Array[Team] = []
		
		for nation: Nation in contient.nations:
			print(nation.name)
			# to save promoted/delegated teams by league
			
			var teams_buffer: Dictionary = {}
			for year: int in range(current_year, current_year - HISTORY_YEARS, -1):
				print(year)
				if not teams_buffer.is_empty():
					print()
					for league: League in nation.leagues:
						print("teams before" + str(league.teams.size()))
					
					# switch them with teams from upper/lower division
					for league: League in nation.leagues:
						print("pyramid level " + str(league.pyramid_level) + "\n")
						
						var promoted_teams: Array[Team] = teams_buffer["p"][league.pyramid_level]
						var delegated_teams: Array[Team] = teams_buffer["d"][league.pyramid_level]
						
						# start with backup teams
						# prevents array out of bounds, in case if only one league in nation
						# this code runs if this is last league by pyramid level or only one league is present
						if league.pyramid_level == nation.leagues.size():
							# make sure there are as many backup teams as delegated
							if nation.backup_teams.size() < delegated_teams.size():
								delegated_teams = delegated_teams.slice(0, nation.backup_teams.size())
							
							# remove delegated from league
							for team: Team in delegated_teams:
								league.teams.erase(team)
							
							# add backup teams to league
							for i: int in delegated_teams.size():
								var backup: Team = RngUtil.pick_random(nation.backup_teams)
								nation.backup_teams.erase(backup)
								league.teams.append(backup)
							
							# add delegated to backup tems
							nation.backup_teams.append_array(delegated_teams)
							
							if nation.leagues.size() > 1:
								# promote
								nation.get_league_by_pyramid_level(league.pyramid_level - 1).teams.append_array(promoted_teams)
								# remove promoted teams from league
								for team: Team in promoted_teams:
									league.teams.erase(team)
							else:
								# add to cup, if only league in nation
								continental_cup_teams.append_array(promoted_teams)
						
						elif league.pyramid_level > 1:
							# promote
							nation.get_league_by_pyramid_level(league.pyramid_level - 1).teams.append_array(promoted_teams)
							# remove promoted teams from league
							for team: Team in promoted_teams:
								league.teams.erase(team)
							
							# delegate
							nation.get_league_by_pyramid_level(league.pyramid_level + 1).teams.append_array(delegated_teams)
							# remove delegated teams
							for team: Team in delegated_teams:
								league.teams.erase(team)
							
						else :
							# first teams go to cup
							continental_cup_teams.append_array(promoted_teams)
							
							# add delegated teams to lower league
							nation.get_league_by_pyramid_level(league.pyramid_level + 1).teams.append_array(delegated_teams)
							
							# remove delegated teams
							for team: Team in delegated_teams:
								league.teams.erase(team)
					
					for league: League in nation.leagues:
						print("teams after" + str(league.teams.size()))
					print("backup teams " + str(nation.backup_teams.size()))
				
				# clear teams
				teams_buffer["d"] = {}
				teams_buffer["p"] = {}
				
				for league: League in nation.leagues:
					# initialize league table
					var table: Table = Table.new()
					for team: Team in league.teams:
						table.add_team(team)
					var match_days: Array[Array] = MatchCombinationUtil.create_combinations(league, league.teams)
					
					# generate random results for previous season, with actual teams
					for match_day: Array in match_days:
						for matchz: Match in match_day:
							var home_goals: int = RngUtil.rng.randi_range(0, 10)
							var away_goals: int = RngUtil.rng.randi_range(0, 10)
							matchz.set_result(home_goals, away_goals)
							table.add_result(
								matchz.home.id, matchz.home_goals, matchz.away.id, matchz.away_goals
							)
					
					# last/first x teams will be promoted delegated
					var sorted_table: Array[TableValues] = table.to_sorted_array()
					
					# reassign delegated/promoted teams
					teams_buffer["d"][league.pyramid_level] = league.teams.filter(
						func(t: Team) -> bool:
							# get last 2 teams
							return t.id == sorted_table[-1].team_id || t.id == sorted_table[-2].team_id
					)
					teams_buffer["p"][league.pyramid_level] = league.teams.filter(
						func(t: Team) -> bool:
							# get first 2 teams
							return t.id == sorted_table[0].team_id || t.id == sorted_table[1].team_id
					)
					
					print("delegated " + str((teams_buffer["d"][league.pyramid_level] as Array).size()))
					print("promoted " + str((teams_buffer["p"][league.pyramid_level] as Array).size()))
					
					# save table in results
					league.tables.insert(0, table)


	# use league tables to calculate possible cup winners
	#for contient: Continent in world.continents:
		## continental club cup
		#for year: int in range(current_year, current_year - HISTORY_YEARS, -1):
			#contient.cup_clubs


func _generate_player_history() -> void:
	pass


func _generate_world_from_csv() -> void:
	world = World.new()
	world.initialize()
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
	var continent_filter: Array[Continent] = world.continents.filter(func(c: Continent) -> bool: return c.name == continent_name)
	if continent_filter.size() == 0:
		continent = Continent.new()
		continent.name = continent_name
		world.continents.append(continent)
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
	
	# create team
	var team: Team = Team.new()
	team.name = team_name
	
	# check if team is backup team
	if league_name.to_lower().strip_edges() == "backup":
		nation.backup_teams.append(team)
	else:
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
		
		league.add_team(team)
