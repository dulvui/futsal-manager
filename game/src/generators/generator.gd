# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
extends Node
class_name Generator

const NAMES_DIR:String = "res://data/player-names/"
const LEAGUES_DIR:String = "res://data/leagues/"

# defines noise added to attribute factors
# exmaple shoot factor = 10 => other attributes vary between 10 -/+ NOISE
const NOISE:int = 3

var player_id:int = 1

var leagues_data:Dictionary = {}
var names:Dictionary = {}

# for birthdays range
var date:Dictionary
var max_timestamp:int
var min_timestamp:int

var rng:RandomNumberGenerator

func generate(random_seed:String) -> Leagues:
	rng = RandomNumberGenerator.new()
	rng.seed = hash(random_seed)
	
	var leagues:Leagues = Leagues.new()
	# create date ranges
	# starts from current year and substracts min/max years
	# youngest player can be 15 and oldest 45
	date = Time.get_date_dict_from_system()
	var max_date:Dictionary = date.duplicate()
	max_date.month = 1
	max_date.day = 1
	max_date.year -= 15 
	max_timestamp = Time.get_unix_time_from_datetime_dict(max_date)
	max_date.year -= 30
	min_timestamp = Time.get_unix_time_from_datetime_dict(max_date)
	
	for nation:String in Constants.Nations:
		
		#TODO create name json for other nations
		#var names_file:FileAccess = FileAccess.open(NAMES_DIR + nation + ".json", FileAccess.READ)
		var names_file:FileAccess = FileAccess.open(NAMES_DIR + "it.json", FileAccess.READ)	
		names["it"] = JSON.parse_string(names_file.get_as_text())
		
		# TODO iterate over all nationalities
		var leagues_file:FileAccess = FileAccess.open(LEAGUES_DIR + nation.to_lower() + ".json", FileAccess.READ)
		leagues_data[nation] = JSON.parse_string(leagues_file.get_as_text())


		for l:Dictionary in leagues_data[nation]:
			print("Generate players for ", l["name"])
			var league:League = League.new()
			league.name = l["name"]
			# TODO change to fit other nations
			league.nation = Constants.Nations.get(nation)
			print(league["teams"])
			for t:String in l["teams"]:
				print(t)
				var team:Team = Team.new()
				team.name = t
				team.id = team.name.md5_text()
				team.budget = rng.randi_range(500000, 100000000)
				team.salary_budget = rng.randi_range(500000, 100000000)
				team.colors = []
				team.colors.append(Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1)))
				team.colors.append(team.colors[0].inverted())
				team.colors.append(Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1)))
				
				team.create_stadium(t + "Stadium", 1234, 1990)
				assign_players_to_team(team, league)
				league.add_team(team)
				
			leagues.add_league(league)
	
	return leagues


func assign_players_to_team(p_team:Team, p_league:League) -> Team:
	var nr:int = 1
	
	for position:int in Player.Position.values():
		
		var amount:int = rng.randi_range(2, 5)
		if position == Player.Position.G:
			amount = 3
		
		for i in amount:
			var player:Player = create_player(Constants.Nations.ITALY, position, nr)
			nr += 1
			player.team = p_team.name
			player.league = p_league.name
			p_team.players.append(player)
		
			# rng.random lineup assingment
			if position == Player.Position.G and p_team.lineup_player_ids.is_empty():
				p_team.lineup_player_ids.append(player.id)
			elif position != Player.Position.G and p_team.lineup_player_ids.size() < Constants.LINEUP_PLAYERS_AMOUNT:
				p_team.lineup_player_ids.append(player.id)

	return p_team

func get_goalkeeper_attributes(age:int, prestige:int, position:Player.Position) -> Goalkeeper:
	var attributes:Goalkeeper = Goalkeeper.new()
	
	var age_factor:int = get_age_factor(age)
	var factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))
	
	# goalkeepers have max potential of 20 
	var max_potential:int = 20
	
	# non-goalkeepers have max potential of 10, since they could play as gaolkeeer in a 4 + 1 fieldplayer situation
	if position != Player.Position.G:
		max_potential = 10

	attributes.reflexes = min(factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.positioning = min(factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.kicking = min(factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.handling = min(factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.diving = min(factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.speed = min(factor + rng.randi_range(-NOISE, NOISE), max_potential)
	return attributes


func get_physical(age:int, prestige:int, position:Player.Position) -> Physical:
	var attributes:Physical = Physical.new()

	var age_factor:int = get_age_factor(age)

	var pace_factor:int = min(rng.randi_range(9, age_factor), max(prestige, 9))
	var physical_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))
	
	# non goalkeepers have max potential of 20 
	var max_potential:int = 20
	
	# goalkeepers have max potential of 10, since they could play as gaolkeeer in a 4 + 1 fieldplayer situation
	if position == Player.Position.G:
		max_potential = 15
	
	attributes.pace = min(pace_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.acceleration = min(pace_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.stamina = min(physical_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.strength = min(physical_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.agility = min(physical_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.jump = min(physical_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	
	return attributes


func get_technical(age:int, prestige:int, position:Player.Position) -> Technical:
	var attributes:Technical = Technical.new()
	
	var age_factor:int = get_age_factor(age)

	# use also pos i calculation
	var pass_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))
	var shoot_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))
	var technique_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))
	var defense_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))

	
	# non goalkeepers have max potential of 20 
	var max_potential:int = 20
	
	# goalkeepers have max potential of 10, since they could play as gaolkeeer in a 4 + 1 fieldplayer situation
	if position == Player.Position.G:
		max_potential = 15
	attributes.crossing = min(pass_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.passing = min(pass_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.long_passing = min(pass_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.tackling = min(defense_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.heading = min(shoot_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.interception = min(defense_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.shooting = min(shoot_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.long_shooting = min(shoot_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.penalty = min(technique_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.finishing = min(shoot_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.dribbling = min(shoot_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	attributes.blocking = min(shoot_factor + rng.randi_range(-NOISE, NOISE), max_potential)
	return attributes


func get_mental(age:int, prestige:int, position:Player.Position) -> Mental:
	
	var attribtues:Mental = Mental.new()
	
	var age_factor:int = get_age_factor(age)

	var offensive_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))
	var defensive_factor:int = min(rng.randi_range(NOISE + 1, age_factor), max(prestige, NOISE + 1))

	attribtues.aggression = min(defensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.anticipation = min(defensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.marking = min(defensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	
	attribtues.decisions = min(offensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.concentration = min(offensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.teamwork = min(offensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.vision = min(offensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.work_rate = min(offensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	attribtues.offensive_movement = min(offensive_factor + rng.randi_range(-NOISE, NOISE), 20)
	
	return attribtues

func get_age_factor(age:int ) -> int:
	var age_factor:int = 20
	if age > 34:
		age_factor = max(54 - age, 16)
	elif age < 18:
		age_factor = 16
	return age_factor

func get_price(age:int, prestige:int, position:Player.Position) -> int:
	var age_factor:int = min(abs(age - 30), 20)
	var pos_factor:int = 0
	if position == Player.Position.G:
		pos_factor = 5
	elif position == Player.Position.D:
		pos_factor = 10
	elif position == Player.Position.W:
		pos_factor = 15
	else:
		pos_factor = 20

	var total_factor:int = age_factor + pos_factor + prestige

	return rng.randi_range(total_factor-20, total_factor) * 10000

func get_random_foot() -> Player.Foot:
	if rng.randi() % 5 == 0:
		return Player.Foot.L
	return Player.Foot.R
	
func get_random_form() -> Player.Form:
	var factor:int =  rng.randi() % 100
	if factor < 5:
		return Player.Form.Injured
	elif factor < 15:
		return Player.Form.Recover
	elif factor < 60:
		return Player.Form.Good
	return Player.Form.Excellent
		
func get_random_morality() -> Player.Morality:
	var factor:int =  rng.randi() % 100
	if factor < 5:
		return Player.Morality.Horrible
	elif factor < 15:
		return Player.Morality.Bad
	elif factor < 60:
		return Player.Morality.Good
	return Player.Morality.Excellent

func get_contract(prestige:int, position:int, age:int) -> Contract:
	var contract:Contract = Contract.new()
	
	contract.income = 0
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
	
func get_player_name(nationality:Constants.Nations) -> String:
	# TODO combine with other nations, but with low probability
	var size:int = names["it"]["names"].size()
	return names["it"]["names"][rng.randi() % size]
	
func get_surname(nationality:Constants.Nations) -> String:
	# TODO combine with other nations, but with low probability
	var size:int = names["it"]["last_names"].size()
	return names["it"]["last_names"][rng.randi() % size]

func create_player(nationality:Constants.Nations, position:Player.Position, nr:int) -> Player:
	var player:Player = Player.new()
	# rng.random date from 1970 to 2007
	var birth_date:Dictionary = Time.get_datetime_dict_from_unix_time(rng.randi_range(0, max_timestamp))

	var prestige:int = rng.randi_range(1, Constants.MAX_PRESTIGE)
	# to make just a few really good and a few really bad
	if prestige < 30:
		prestige = rng.randi_range(1, 5)
	if prestige > 90:
		prestige = rng.randi_range(15, 20)
	else:
		prestige = rng.randi_range(5, 15)

	player.id = player_id
	player.price = get_price(date.year-birth_date.year, prestige, position)
	player.name = get_player_name(nationality)
	player.surname = get_surname(nationality)
	player.birth_date = birth_date
	player.nationality = str(nationality)
	player.moral = rng.randi_range(1, 4)  # 1 to 4, 1 low 4 good
	player.position = position
	player.foot = get_random_foot()
	player.morality = get_random_morality()
	player.form = get_random_form()
	player.prestige = prestige
	player.injury_factor = rng.randi_range(1, 20)
	player.loyality = rng.randi_range(1, 20) # if player is loyal, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
	player.contract = get_contract(prestige, position, date.year-birth_date.year)
	player.nr = nr
	
	player.attributes = Attributes.new()
	player.attributes.goalkeeper =  get_goalkeeper_attributes(date.year-birth_date.year, prestige, position)
	player.attributes.mental = get_mental(date.year-birth_date.year, prestige, position)
	player.attributes.technical = get_technical(date.year-birth_date.year, prestige, position)
	player.attributes.physical = get_physical(date.year-birth_date.year, prestige, position)
	
	# TODO  create rng.random history
	var statistics:Statistics = Statistics.new()
	statistics.team_name = "Test"
	statistics.games_played = 0
	statistics.goals = 0
	statistics.assists = 0
	statistics.yellow_card = 0
	statistics.red_card = 0
	statistics.average_vote = 0
	player.statistics.append(statistics)
	
	player_id += 1

	return player
