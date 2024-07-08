# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name Generator
extends Node

const NAMES_DIR: String = "res://data/player_names/"
const LEAGUES_DIR: String = "res://data/leagues/"

# defines noise added to attribute factors
const NOISE: int = 3

var leagues_data: Dictionary = {}
var names: Dictionary = {}

# for birthdays range
var date: Dictionary
var max_timestamp: int
var min_timestamp: int


func generate_leagues() -> Leagues:
	var leagues: Leagues = Leagues.new()
	# create date ranges
	# starts from current year and subtracts min/max years
	# youngest player can be 15 and oldest 45
	date = Config.start_date
	var max_date: Dictionary = date.duplicate()
	max_date.month = 1
	max_date.day = 1
	max_date.year -= 15
	max_timestamp = Time.get_unix_time_from_datetime_dict(max_date)
	max_date.year -= 30
	min_timestamp = Time.get_unix_time_from_datetime_dict(max_date)

	# initialize names
	for nation: String in Const.Nations:
		var names_file: FileAccess = FileAccess.open(
			NAMES_DIR + nation.to_lower() + ".json", FileAccess.READ
		)
		names[nation.to_lower()] = JSON.parse_string(names_file.get_as_text())

	# create leagues. teams and players
	for nation: String in Const.Nations:
		var leagues_file: FileAccess = FileAccess.open(
			LEAGUES_DIR + nation.to_lower() + ".json", FileAccess.READ
		)
		leagues_data[nation] = JSON.parse_string(leagues_file.get_as_text())
		# used for prestige calculation, so that high leagues have better prestige
		var pyramid_level: int = 1

		for l: Dictionary in leagues_data[nation]:
			var league: League = League.new()
			league.name = l.name
			league.pyramid_level = pyramid_level
			league.nation = Const.Nations.get(nation)
			for t: String in l.teams:
				var team: Team = Team.new()
				team.name = t
				team.budget = Config.rng.randi_range(500000, 100000000)
				team.salary_budget = Config.rng.randi_range(500000, 100000000)
				team.colors = []
				team.colors.append(
					Color(
						Config.rng.randf_range(0, 1),
						Config.rng.randf_range(0, 1),
						Config.rng.randf_range(0, 1)
					)
				)
				team.colors.append(team.colors[0].inverted())
				team.colors.append(
					Color(
						Config.rng.randf_range(0, 1),
						Config.rng.randf_range(0, 1),
						Config.rng.randf_range(0, 1)
					)
				)

				team.create_stadium(t + "Stadium", 1234, 1990)
				

				var temp_team_prestige: int = get_team_prestige(pyramid_level)
				assign_players_to_team(team, league, temp_team_prestige)

				team.staff = create_staff(team.get_prestige(), league.nation, league.pyramid_level)
				league.add_team(team)

			leagues.add_league(league)
			pyramid_level += 1

	return leagues


func assign_players_to_team(p_team: Team, p_league: League, prestige: int) -> Team:
	var nr: int = 1

	for position_type: int in Position.Type.values():
		var amount: int = Config.rng.randi_range(2, 5)
		if position_type == Position.Type.G:
			amount = 3

		for i in amount:
			var random_nation: Const.Nations = get_random_nationality(
				p_league.nation, prestige, p_league.pyramid_level
			)
			var player: Player = create_player(random_nation, nr, prestige, position_type)
			nr += 1
			player.team = p_team.name
			player.team_id = p_team.id
			player.league = p_league.name
			p_team.players.append(player)

			# Config.rng.random lineup assignment
			if position_type == Position.Type.G and p_team.lineup_player_ids.is_empty():
				p_team.lineup_player_ids.append(player.id)
			elif (
				position_type != Position.Type.G
				and p_team.lineup_player_ids.size() < Const.LINEUP_PLAYERS_AMOUNT
			):
				p_team.lineup_player_ids.append(player.id)

	return p_team


func get_goalkeeper_attributes(age: int, prestige: int, position: Position) -> Goalkeeper:
	var attributes: Goalkeeper = Goalkeeper.new()

	var age_factor: int = get_age_factor(age)
	var factor: int = in_bounds_random(prestige + age_factor)

	# goalkeepers have max potential of 20
	var max_potential: int = in_bounds_random(factor)

	# non-goalkeepers have max potential of 10, since they could play as goalkeeper in a 4 + 1 field player situation
	if position.type != Position.Type.G:
		max_potential /= 2

	attributes.reflexes = in_bounds_random(factor, max_potential)
	attributes.positioning = in_bounds_random(factor, max_potential)
	attributes.kicking = in_bounds_random(factor, max_potential)
	attributes.handling = in_bounds_random(factor, max_potential)
	attributes.diving = in_bounds_random(factor, max_potential)
	attributes.speed = in_bounds_random(factor, max_potential)
	return attributes


func get_physical(age: int, prestige: int, position: Position) -> Physical:
	var attributes: Physical = Physical.new()

	var age_factor: int = get_physical_age_factor(age)

	var pace_factor: int = in_bounds_random(prestige + age_factor)
	var physical_factor: int = in_bounds_random(prestige + age_factor)

	# non goalkeepers have max potential
	var max_potential: int = in_bounds_random(prestige)

	# goalkeepers have max potential of 10, since they could play as goalkeeper in a 4 + 1 field player situation
	if position.type == Position.Type.G:
		max_potential /= 2

	attributes.pace = in_bounds_random(pace_factor, max_potential)
	attributes.acceleration = in_bounds_random(pace_factor, max_potential)
	attributes.stamina = in_bounds_random(physical_factor, max_potential)
	attributes.strength = in_bounds_random(physical_factor, max_potential)
	attributes.agility = in_bounds_random(physical_factor, max_potential)
	attributes.jump = in_bounds_random(physical_factor, max_potential)

	return attributes


func get_technical(age: int, prestige: int, position: Position) -> Technical:
	var attributes: Technical = Technical.new()

	var age_factor: int = get_age_factor(age)

	# use also pos i calculation
	var pass_factor: int = in_bounds_random(prestige + age_factor)
	var shoot_factor: int = in_bounds_random(prestige + age_factor)
	var technique_factor: int = in_bounds_random(prestige + age_factor)
	var defense_factor: int = in_bounds_random(prestige + age_factor)

	# non goalkeepers have max potential
	var max_potential: int = in_bounds_random(prestige)

	# goalkeepers have max potential of 10, since they could play as goalkeeper in a 4 + 1 field player situation
	if position.type == Position.Type.G:
		max_potential /= 2

	attributes.crossing = in_bounds_random(pass_factor, max_potential)
	attributes.passing = in_bounds_random(pass_factor, max_potential)
	attributes.long_passing = in_bounds_random(pass_factor, max_potential)
	attributes.tackling = in_bounds_random(defense_factor, max_potential)
	attributes.heading = in_bounds_random(shoot_factor, max_potential)
	attributes.interception = in_bounds_random(defense_factor, max_potential)
	attributes.shooting = in_bounds_random(shoot_factor, max_potential)
	attributes.long_shooting = in_bounds_random(shoot_factor, max_potential)
	attributes.penalty = in_bounds_random(technique_factor, max_potential)
	attributes.finishing = in_bounds_random(shoot_factor, max_potential)
	attributes.dribbling = in_bounds_random(shoot_factor, max_potential)
	attributes.blocking = in_bounds_random(shoot_factor, max_potential)
	return attributes


func get_mental(age: int, prestige: int) -> Mental:
	var attribtues: Mental = Mental.new()

	var age_factor: int = get_age_factor(age)

	var offensive_factor: int = in_bounds_random(prestige + age_factor)
	var defensive_factor: int = in_bounds_random(prestige + age_factor)

	var max_potential: int = in_bounds_random(prestige)

	attribtues.aggression = in_bounds_random(defensive_factor, max_potential)
	attribtues.anticipation = in_bounds_random(defensive_factor, max_potential)
	attribtues.marking = in_bounds_random(defensive_factor, max_potential)

	attribtues.decisions = in_bounds_random(offensive_factor, max_potential)
	attribtues.concentration = in_bounds_random(offensive_factor, max_potential)
	attribtues.teamwork = in_bounds_random(offensive_factor, max_potential)
	attribtues.vision = in_bounds_random(offensive_factor, max_potential)
	attribtues.work_rate = in_bounds_random(offensive_factor, max_potential)
	attribtues.offensive_movement = in_bounds_random(offensive_factor, max_potential)

	return attribtues


func get_physical_age_factor(age: int) -> int:
	# for  24 +- noise <  age factor is negative
	if age < 24 + noise():
		return Config.rng.randi_range(-5, 3)
	return Config.rng.randi_range(1, 7)


func get_age_factor(age: int) -> int:
	# for  34 +- noise < age < 18 +- noise age factor is negative
	if age > 34 + noise() or age < 18 + noise():
		return Config.rng.randi_range(-5, 1)
	# else age factor is positive
	return Config.rng.randi_range(-1, 5)


func get_price(age: int, prestige: int, position: Position) -> int:
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

	return Config.rng.randi_range(max(total_factor - 20, 0), total_factor) * 1000


func get_random_foot() -> Player.Foot:
	if Config.rng.randi() % 5 == 0:
		return Player.Foot.L
	return Player.Foot.R


func get_random_form() -> Player.Form:
	var factor: int = Config.rng.randi() % 100
	if factor < 5:
		return Player.Form.Injured
	elif factor < 15:
		return Player.Form.Recover
	elif factor < 60:
		return Player.Form.Good
	return Player.Form.Excellent


func get_random_morality() -> Player.Morality:
	var factor: int = Config.rng.randi() % 100
	if factor < 5:
		return Player.Morality.Horrible
	elif factor < 15:
		return Player.Morality.Bad
	elif factor < 60:
		return Player.Morality.Good
	return Player.Morality.Excellent


func get_contract(person: Person) -> Contract:
	var contract: Contract = Contract.new()
	contract.income = person.prestige * person.get_age()  # TODO use better logic
	contract.start_date = Time.get_date_dict_from_system()
	contract.end_date = Time.get_date_dict_from_system()
	contract.bonus_goal = 0
	contract.bonus_clean_sheet = 0
	contract.bonus_assist = 0
	contract.bonus_league_title = 0
	contract.bonus_nat_cup_title = 0
	contract.bonus_inter_cup_title = 0
	contract.buy_clause = 0
	contract.is_on_loan = false
	return contract


func get_person_name(nationality: Const.Nations) -> String:
	# TODO randomly use names from other nations, with low probability 
	var nation_string: String = (Const.Nations.keys()[nationality] as String).to_lower()

	if Config.generation_gender == Const.Gender.MALE:
		var size: int = (names[nation_string]["first_names_male"] as Array).size()
		return names[nation_string]["first_names_male"][Config.rng.randi() % size]
	elif Config.generation_gender == Const.Gender.FEMALE:
		var size: int = (names[nation_string]["first_names_female"] as Array).size()
		return names[nation_string]["first_names_female"][Config.rng.randi() % size]
	else:
		var size_female: int = (names[nation_string]["first_names_female"] as Array).size()
		var size_male: int = (names[nation_string]["first_names_male"] as Array).size()
		var female_names: Array = names[nation_string]["first_names_female"]
		var male_names: Array = names[nation_string]["first_names_male"]

		var mixed_names: Array = []
		mixed_names.append_array(female_names)
		mixed_names.append_array(male_names)

		return mixed_names[Config.rng.randi() % (size_female + size_male)]


func get_person_surname(nationality: Const.Nations) -> String:
	# TODO combine with other nations, but with low probability
	# to have players with other nations surnames in different nation
	# biiger proability for neighbour nations (needs data)
	var nation_string: String = Const.Nations.keys()[nationality]
	nation_string = nation_string.to_lower()
	var size: int = (names[nation_string]["last_names"] as Array).size()
	return names[nation_string]["last_names"][Config.rng.randi() % size]


func create_staff(team_prestige: int, team_nationality: Const.Nations, pyramid_level: int) -> Staff:
	var staff: Staff = Staff.new()
	staff.manager = create_manager(team_prestige, team_nationality, pyramid_level)
	staff.president = create_president(team_prestige, team_nationality, pyramid_level)
	staff.scout = create_scout(team_prestige, team_nationality, pyramid_level)
	return staff


func create_manager(team_prestige: int, team_nation: Const.Nations, pyramid_level: int) -> Manager:
	var manager: Manager = Manager.new()
	manager.prestige = in_bounds_random(team_prestige)
	manager.name = get_person_name(manager.nation)
	manager.surname = get_person_surname(manager.nation)
	manager.nation = get_random_nationality(team_nation, team_prestige, pyramid_level)
	
	manager.contract = get_contract(manager)
	
	return manager


func create_president(team_prestige: int, team_nation: Const.Nations, pyramid_level: int) -> President:
	var president: President = President.new()
	president.prestige = in_bounds_random(team_prestige)
	president.name = get_person_name(president.nation)
	president.surname = get_person_surname(president.nation)
	president.nation = get_random_nationality(team_nation, team_prestige, pyramid_level)
	president.contract = get_contract(president)
	return president


func create_scout(team_prestige: int, team_nation: Const.Nations, pyramid_level: int) -> Scout:
	var scout: Scout = Scout.new()
	scout.prestige = in_bounds_random(team_prestige)
	scout.name = get_person_name(scout.nation)
	scout.surname = get_person_surname(scout.nation)
	scout.nation = get_random_nationality(team_nation, team_prestige, pyramid_level)
	scout.contract = get_contract(scout)
	return scout


func create_player(
	nationality: Const.Nations, nr: int, p_prestige: int, p_position_type: Position.Type
) -> Player:
	var player: Player = Player.new()
	random_positions(player, p_position_type)
	
	# Config.rng.random date from 1970 to 2007
	var birth_date: Dictionary = Time.get_datetime_dict_from_unix_time(
		Config.rng.randi_range(0, max_timestamp)
	)

	var prestige: int = get_player_prestige(p_prestige)

	player.price = get_price(date.year - birth_date.year, prestige, player.position)
	player.name = get_person_name(nationality)
	player.surname = get_person_surname(nationality)
	player.birth_date = birth_date
	player.nation = nationality
	player.foot = get_random_foot()
	player.morality = get_random_morality()
	player.form = get_random_form()
	player.prestige = prestige
	player.injury_factor = Config.rng.randi_range(1, 20)
	player.loyality = Config.rng.randi_range(1, 20)  # if player is loyal, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
	player.contract = get_contract(player)
	player.nr = nr

	player.attributes = Attributes.new()
	player.attributes.goalkeeper = get_goalkeeper_attributes(
		date.year - birth_date.year, prestige, player.position
	)
	player.attributes.mental = get_mental(date.year - birth_date.year, prestige)
	player.attributes.technical = get_technical(date.year - birth_date.year, prestige, player.position)
	player.attributes.physical = get_physical(date.year - birth_date.year, prestige, player.position)

	# TODO  create Config.rng.random history
	var statistics: Statistics = Statistics.new()
	statistics.team_name = "Test"
	statistics.games_played = 0
	statistics.goals = 0
	statistics.assists = 0
	statistics.yellow_card = 0
	statistics.red_card = 0
	statistics.average_vote = 0
	player.statistics.append(statistics)

	return player

func random_positions(player: Player, p_position_type: Position.Type) -> void:
	# assign main positions
	var position: Position = Position.new()
	position.type = p_position_type
	position.random_variations()
	player.position = position

	# TODO should goalkeeper have alt positions?
	# TODO adapt to make alteratrios more cohereant
	# to attributes, like defender should have good defense stats
	var alt_positions: Array[Position] = []
	var alt_positions_keys: Array[Variant] = Position.Type.values()
	Config.shuffle(alt_positions_keys)
	
	for i: int in Config.rng.randi_range(0, alt_positions_keys.size()):
		var alt_position: Position = Position.new()
		alt_position.type = alt_positions_keys[i]
		alt_position.random_variations()
		alt_positions.append(alt_position)
	
	player.alt_positions = alt_positions


func get_player_prestige(team_prestige: int) -> int:
	# player prestige is teams prestige +- 5
	return in_bounds_random(team_prestige)


func get_team_prestige(pyramid_level: int) -> int:
	var minp: int = Const.MAX_PRESTIGE - pyramid_level * ((Config.rng.randi() % 5) + 1)
	var maxp: int = Const.MAX_PRESTIGE - ((pyramid_level - 1) * 3)
	return in_bounds(Config.rng.randi_range(minp, maxp))


func get_random_nationality(
	nationality: Const.Nations, prestige: int, pyramid_level: int
) -> Const.Nations:
	# (100 - prestige)% given nation, prestige% random nation
	# with prestige, lower division teams have less players from other nations
	if Config.rng.randi_range(1, 100) > 100 - (prestige * 2 / pyramid_level):
		return Const.Nations.values()[Config.rng.randi_range(0, Const.Nations.values().size() - 1)]
	return nationality


func noise(factor: int = NOISE) -> int:
	return Config.rng.randi_range(-factor, factor)


func abs_noise(factor: int = NOISE) -> int:
	return Config.rng.randi_range(0, factor)


func in_bounds_random(value: int, max_bound: int = Const.MAX_PRESTIGE) -> int:
	var random_value: int = value + noise()
	return in_bounds(random_value, max_bound)


# returns value between 1 and 20
func in_bounds(value: int, max_bound: int = Const.MAX_PRESTIGE) -> int:
	return maxi(mini(value, max_bound), 1)
