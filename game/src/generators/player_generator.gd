# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
@tool
extends EditorScript

# goal keeper, winger, pivot, defender, universal
var positions = ["G", "D", "W", "P", "U"]
var foots = ["L", "R", "R", "R", "R"]  # 80% right foot
var forms = ["INJURED", "RECOVER", "GOOD", "PERFECT"]
# transfer_states = ["TRANSFER","LOAN","FREE_AGENT"]
# nationalyty = ["BR","ES","ARG","IT","FR","IND","GER","POR"]
var names:Array[String]
var surnames:Array[String]

var team_id:int = 15  # last id of serie-a team is 14
var player_id:int = 1

var test_league:League

func _run():
	var file_name:String = "res://test_league.tres" 
	print("Generate players...")
	var test_team:Team = Team.new()
	test_team.name = "test"
	test_team.budget = 1234
	test_team.create_stadium("Stadium", 1234, 1990)
	
	test_league = League.new()
	test_league.id = 0
	test_league.name = "Test League"
	test_league.country = "IT"
	
	
	test_league.add_team(test_team)
	
	assign_players_to_team(test_team)
	
	print("Write to file...")
	print("Write league ", test_league.name)
	ResourceSaver.save(test_league, file_name)
	print("Done.")
	
	print("Reading from file...")
	var read_test_league:League = load(file_name)
	print("Read team name ", read_test_league.name)
	print("Read team teams size ", read_test_league.teams.size())


func assign_players_to_team(team:Team):
	var id:int = 1
	team.id = id
	id += 1

	var nr:int = 1
	# G
	var g1:Player = create_player("it_IT", "G", nr)
	nr += 1
	team.players.append(g1)
	for i in randi_range(3, 5):
		var g2:Player = create_player("it_IT", "G", nr)
		team.players.append(g2)
		nr += 1
	# D
	var d1:Player = create_player("it_IT", "D", nr)
	team.players.append(d1)
	nr += 1
	for i in randi_range(3, 5):
		var d2 = create_player("it_IT", "D", nr)
		team.players.append(d2)
		nr += 1
	# WL
	var wl1:Player = create_player("it_IT", "WL", nr)
	team.players.append(wl1)
	nr += 1
	for i in randi_range(2, 4):
		var wl2 = create_player("it_IT", "WL", nr)
		team.players.append(wl2)
		nr += 1

	# WR
	var wr1:Player = create_player("it_IT", "WR", nr)
	team.players.append(wr1)
	nr += 1
	for i in randi_range(2, 4):
		var wl2:Player = create_player("it_IT", "WR", nr)
		team.players.append(wl2)
		nr += 1
	# P
	var p1:Player = create_player("it_IT", "P", nr)
	team.players.append(p1)
	nr += 1

	for i in randi_range(2, 4):
		var p2:Player = create_player("it_IT", "P", nr)
		team.players.append(p2)
		nr += 1

	# U
	for i in randi_range(2, 4):
		var u = create_player("it_IT", "U", nr)
		team.players.append(u)
		nr += 1

	return team

func get_goalkeeper_attributes(age:int, nationality:String, prestige:int, position:String) -> Goalkeeper:
	var attributes:Goalkeeper = Goalkeeper.new()
	
	var age_factor:int = get_age_factor(age)
	var factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	
	if position == "G":
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


func get_physical(age, nationality, prestige, pos) -> Physical:
	var attributes:Physical = Physical.new()

	var age_factor:int = get_age_factor(age)

	var pace_factor:int = min(randi_range(9, age_factor), max(prestige, 9))
	var physical_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	
	if pos != "G":
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


func get_technical(age, nationality, prestige, pos) -> Technical:
	var attributes:Technical = Technical.new()
	
	var age_factor:int = get_age_factor(age)

	# use also pos i calculation
	var pass_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var shoot_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var technique_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var defense_factor:int = min(randi_range(6, age_factor), max(prestige, 6))

	if pos != "G":
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


func get_mental(age, nationality, prestige, pos) -> Mental:
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
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16
	return age_factor

func get_price(age, prestige, pos) -> int:
	var age_factor:int = min(abs(age - 30), 20)
	var pos_factor:int = 0
	if pos == "G":
		pos_factor = 5
	elif pos == "D":
		pos_factor = 10
	elif pos == "W":
		pos_factor = 15
	else:
		pos_factor = 20

	var total_factor:int = age_factor + pos_factor + prestige

	return randi_range(total_factor-20, total_factor) * 10000


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


func get_history(prestige, position, age, contract, potential_growth):
	var past:int = randi_range(1, 2)
	var future:int = randi_range(1, 3)

	# price_factor = randi_range()

	# look at years in contract, so before he played in other club
	# look at potential growth and stats of player and increase price over years
	# save also price evolution

	var history:Array = [
		{
			"year": "",
			"teams": [
				{
					"name": "",
					"price": 0,
							"games_played": 0,
					"goals": 0,
					"assists": 0,
					"yellow_card": 0,
					"red_card": 0,
					"average_vote": 0.0
				}  # if player had transfer, another team gets added here
			],
			"actual": {  # make own for every competition like cups like in fm 13
				"price": 0,
				"games_played": 0,
				"goals": 0,
				"assists": 0,
				"yellow_card": 0,
				"red_card": 0,
				"average_vote": 0.0
			}
		}
	]
	return history


func create_player(nationality:String, position:String, nr:int) -> Player:
	# player = {}

	# ITALY

	# names = []
	# surnames = []

	# # create names
	# for _ in range(100):
	#     name_base = fake_it.name_male().replace("Dott. ", "").replace("Sig. ", "")
	#     names.append(name_base.split()[0])
	#     surnames.append(name_base.split()[1])

	# create players

	# random date from 1970 to 2007
	var player = Player.new()
	
	var birth_date:Dictionary = Time.get_datetime_dict_from_unix_time(randi_range(0, 1167606000))

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
	player.price = get_price(2020-birth_date.year, prestige, position)
	player.name = "random.choice(names)"
	player.surname = "random.choice(surnames)"
	player.birth_date = birth_date
	player.nationality = nationality.split("_")[1]
	player.moral = randi_range(1, 4)  # 1 to 4, 1 low 4 good
#	player.position = position
	player.foot = foots[randi_range(0, len(foots)-1)]
	player.prestige = prestige
	player.form = forms[randi_range(0, len(forms)-1)]
	player.potential_growth
	player.potential_growth = potential_growth
	player.injury_potential = randi_range(1, 20)
	player.loyality = ""  # if player is loay, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
#	player.history = get_history(prestige, position, 2020-birth_date.year, contract, potential_growth)
	player.contract = get_contract(prestige, position, 2020-birth_date.year)
	player.nr = nr
	
	player.attributes = Attributes.new()
	player.attributes.goalkeeper =  get_goalkeeper_attributes(2020-birth_date.year, nationality, prestige, position)
	player.attributes.mental = get_mental(2020-birth_date.year, nationality, prestige, position)
	player.attributes.technical = get_technical(2020-birth_date.year, nationality, prestige, position)
	player.attributes.physical = get_physical(2020-birth_date.year, nationality, prestige, position)


	player_id += 1

	return player
