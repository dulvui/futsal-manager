# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
@tool
extends EditorScript

const NAMES_DIR:String = "res://data/player-names/"
const LEAGUES_DIR:String = "res://data/leagues/"

var team_id:int = 15  # last id of serie-a team is 14
var player_id:int = 1

var league:League

var leagues:Dictionary = {}
var names:Dictionary = {}

# for birthdays range
var date:Dictionary
var max_timestamp:int
var min_timestamp:int

func _run():
	# create date ranges
	# starts from current year and substracts min/max years
	# youngest player can be 15 and oldest 45
	date = Time.get_date_dict_from_system()
	var max_date = date.duplicate()
	max_date.month = 1
	max_date.day = 1
	max_date.year -= 15 
	max_timestamp = Time.get_unix_time_from_datetime_dict(max_date)
	max_date.year -= 30
	min_timestamp = Time.get_unix_time_from_datetime_dict(max_date)
	
	# TODO iterate over all nationalities
	var names_file = FileAccess.open(NAMES_DIR + "it.json", FileAccess.READ)
	names["it"] = JSON.parse_string(names_file.get_as_text())
	
	# TODO iterate over all nationalities
	var leagues_file = FileAccess.open(LEAGUES_DIR + "it.json", FileAccess.READ)
	leagues["it"] = JSON.parse_string(leagues_file.get_as_text())
	


	for l in leagues["it"]:
		var file_name:String = Constants.LEAGUES_DIR + l["name"].replace(" ", "-").to_lower() +".tres" 
		print("Generate players for ", l["name"])
		var league:League = League.new()
		league.id = l["name"].md5_text()
		league.name = l["name"]
		# TODO change to fit other nations
		league.nation = League.Nations.IT
		print(league["teams"])
		for t in l["teams"]:
			print(t)
			var team:Team = Team.new()
			team.name = t
			team.budget = 1234
			team.create_stadium(t + "Stadium", 1234, 1990)
			assign_players_to_team(team)
			league.add_team(team)
		
		print("Write to file...")
		print("Write league ", league.name)
		ResourceSaver.save(league, file_name)
		print("Done.")
		
		print("Reading from file...")
		var read_league:League = load(file_name)
		print("Read team name ", read_league.name)
		print("Read team teams size ", read_league.teams.size())


func assign_players_to_team(team:Team):
	var id:int = 1
	team.id = id
	id += 1
	var nr:int = 1
	
	team.line_up = LineUp.new()
	
	for position in Player.Position.values():
		
		var amount = randi_range(2, 5)
		if position == Player.Position.G:
			amount = 3
		
		for i in range(amount):
			var player:Player = create_player(League.Nations.IT, position, nr)
			nr += 1
			team.players.append(player)
		
		# random lineup assingment
		if position == Player.Position.G:
			team.line_up.goalkeeper = team.players[-1]
		elif team.line_up.players.size() < 4:
			team.line_up.players.append(team.players[-1])

	return team

func get_goalkeeper_attributes(age:int, prestige:int, position:Player.Position) -> Goalkeeper:
	var attributes:Goalkeeper = Goalkeeper.new()
	
	var age_factor:int = get_age_factor(age)
	var factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	
	if position == Player.Position.G:
		attributes.reflexes = min(factor + randi_range(-5, 5), 20)
		attributes.positioning = min(factor + randi_range(-5, 5), 20)
		attributes.kicking = min(factor + randi_range(-5, 5), 20)
		attributes.handling = min(factor + randi_range(-5, 5), 20)
		attributes.diving = min(factor + randi_range(-5, 5), 20)
		attributes.speed = min(factor + randi_range(-5, 5), 20)
	else:
		attributes.reflexes = -1
		attributes.positioning = -1
		attributes.kicking = -1
		attributes.handling = -1
		attributes.diving = -1
		attributes.speed = -1
	return attributes


func get_physical(age:int, prestige:int, position:Player.Position) -> Physical:
	var attributes:Physical = Physical.new()

	var age_factor:int = get_age_factor(age)

	var pace_factor:int = min(randi_range(9, age_factor), max(prestige, 9))
	var physical_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	
	if position != Player.Position.G:
		attributes.pace = min(pace_factor + randi_range(-5, 5), 20)
		attributes.acceleration = min(pace_factor + randi_range(-5, 5), 20)
		attributes.stamina = min(physical_factor + randi_range(-5, 5), 20)
		attributes.strength = min(physical_factor + randi_range(-5, 5), 20)
		attributes.agility = min(physical_factor + randi_range(-5, 5), 20)
		attributes.jump = min(physical_factor + randi_range(-5, 5), 20)
	else:
		attributes.pace = -1
		attributes.acceleration = -1
		attributes.stamina = -1
		attributes.strength = -1
		attributes.agility = -1
		attributes.jump = -1
	return attributes


func get_technical(age:int, prestige:int, position:Player.Position) -> Technical:
	var attributes:Technical = Technical.new()
	
	var age_factor:int = get_age_factor(age)

	# use also pos i calculation
	var pass_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var shoot_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var technique_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var defense_factor:int = min(randi_range(6, age_factor), max(prestige, 6))

	if position != Player.Position.G:
		attributes.crossing = min(pass_factor + randi_range(-5, 5), 20)
		attributes.passing = min(pass_factor + randi_range(-5, 5), 20)
		attributes.long_passing = min(pass_factor + randi_range(-5, 5), 20)
		attributes.tackling = min(defense_factor + randi_range(-5, 5), 20)
		attributes.heading = min(shoot_factor + randi_range(-5, 5), 20)
		attributes.interception = min(defense_factor + randi_range(-5, 5), 20)
		attributes.shooting = min(shoot_factor + randi_range(-5, 5), 20)
		attributes.long_shooting = min(shoot_factor + randi_range(-5, 5), 20)
		attributes.penalty = min(technique_factor + randi_range(-5, 5), 20)
		attributes.finishing = min(shoot_factor + randi_range(-5, 5), 20)
		attributes.dribbling = min(shoot_factor + randi_range(-5, 5), 20)
		attributes.blocking = min(shoot_factor + randi_range(-5, 5), 20)
	else:
		attributes.crossing = -1
		attributes.passing = -1
		attributes.long_passing = -1
		attributes.tackling = -1
		attributes.heading = -1
		attributes.interception = -1
		attributes.shooting = -1
		attributes.long_shooting = -1
		attributes.penalty = -1
		attributes.finishing = -1
		attributes.dribbling = -1
		attributes.blocking = -1
	return attributes


func get_mental(age:int, prestige:int, position:Player.Position) -> Mental:
	
	var attribtues:Mental = Mental.new()
	
	var age_factor:int = get_age_factor(age)

	var offensive_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var defensive_factor:int = min(randi_range(6, age_factor), max(prestige, 6))

	attribtues.aggression = min(defensive_factor + randi_range(-5, 5), 20)
	attribtues.anticipation = min(defensive_factor + randi_range(-5, 5), 20)
	attribtues.decisions = min(offensive_factor + randi_range(-5, 5), 20)
	attribtues.concentration = min(offensive_factor + randi_range(-5, 5), 20)
	attribtues.teamwork = min(offensive_factor + randi_range(-5, 5), 20)
	attribtues.vision = min(offensive_factor + randi_range(-5, 5), 20)
	attribtues.work_rate = min(offensive_factor + randi_range(-5, 5), 20)
	attribtues.offensive_movement = min(offensive_factor + randi_range(-5, 5), 20)
	attribtues.marking = min(defensive_factor + randi_range(-5, 5), 20)
	
	return attribtues

func get_age_factor(age:int ) -> int:
	var age_factor:int = 20
	if age > 34:
		age_factor = max(54 - age, 16)
	elif age < 18:
		age_factor = 16
	return age_factor

func get_price(age, prestige, position:Player.Position) -> int:
	var age_factor:int = min(abs(age - 30), 20)
	var pos_factor:int = 0
	if position == Player.Position.G:
		pos_factor = 5
	elif position == Player.Position.D:
		pos_factor = 10
	elif position == Player.Position.WL or position == Player.Position.WR:
		pos_factor = 15
	else:
		pos_factor = 20

	var total_factor:int = age_factor + pos_factor + prestige

	return randi_range(total_factor-20, total_factor) * 10000

func get_random_foot() -> Player.Foot:
	if randi() % 5 == 0:
		return Player.Foot.L
	return Player.Foot.R
	
func get_random_form() -> Player.Form:
	var factor:int =  randi() % 100
	if factor < 5:
		return Player.Form.Injured
	elif factor < 15:
		return Player.Form.Recover
	elif factor < 60:
		return Player.Form.Good
	return Player.Form.Excellent
		
func get_random_morality() -> Player.Morality:
	var factor:int =  randi() % 100
	if factor < 5:
		return Player.Morality.Horrible
	elif factor < 15:
		return Player.Morality.Bad
	elif factor < 60:
		return Player.Morality.Good
	return Player.Morality.Excellent

func get_contract(prestige, position, age) -> Contract:
	var contract:Contract = Contract.new()
	
	var past:int = randi_range(1, 2)
	var future:int = randi_range(1, 3)

	# price_factor = randi_range()
	contract.price = 0
	contract.money_week = 0
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
	
func get_name(nationality:League.Nations) -> String:
	# TODO combine with other nations, but with low probability
	var size:int = names["it"]["names"].size()
	return names["it"]["names"][randi() % size]
	
func get_surname(nationality:League.Nations) -> String:
	# TODO combine with other nations, but with low probability
	var size:int = names["it"]["last_names"].size()
	return names["it"]["last_names"][randi() % size]

func create_player(nationality:League.Nations, position:Player.Position, nr:int) -> Player:
	

	
	
	var player = Player.new()
	# random date from 1970 to 2007
	var birth_date:Dictionary = Time.get_datetime_dict_from_unix_time(randi_range(0, max_timestamp))

	var prestige:int = randi_range(1, 100)
	# to make just a few really good and a few really bad
	if prestige < 30:
		prestige = randi_range(1, 5)
	if prestige > 90:
		prestige = randi_range(15, 20)
	else:
		prestige = randi_range(5, 15)

	# position = positions[randi_range(0, len(positions)-1)]

	var potential_growth:int = randi_range(1, 5)

	player.id = player_id
	player.price = get_price(date.year-birth_date.year, prestige, position)
	player.name = get_name(nationality)
	player.surname = get_surname(nationality)
	player.birth_date = birth_date
	player.nationality = str(nationality)
	player.moral = randi_range(1, 4)  # 1 to 4, 1 low 4 good
	player.position = position
	player.foot = get_random_foot()
	player.morality = get_random_morality()
	player.form = get_random_form()
	player.prestige = prestige
	player.potential_growth
	player.potential_growth = potential_growth
	player.injury_potential = randi_range(1, 20)
	player.loyality = ""  # if player is loay, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
	player.contract = get_contract(prestige, position, date.year-birth_date.year)
	player.nr = nr
	
	player.attributes = Attributes.new()
	player.attributes.goalkeeper =  get_goalkeeper_attributes(date.year-birth_date.year, prestige, position)
	player.attributes.mental = get_mental(date.year-birth_date.year, prestige, position)
	player.attributes.technical = get_technical(date.year-birth_date.year, prestige, position)
	player.attributes.physical = get_physical(date.year-birth_date.year, prestige, position)
	
	
	var statistics:Statistics = Statistics.new()
	statistics.team_name = "Test"
	statistics.price = 1234
	statistics.games_played = 1234
	statistics.goals = 1234
	statistics.assists = 1234
	statistics.yellow_card = 1234
	statistics.red_card = 1234
	statistics.average_vote = 1234.5
	player.statistics.append(statistics)
	
	player_id += 1

	return player
