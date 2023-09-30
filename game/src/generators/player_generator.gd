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

func get_goalkeeper_attributes(age:int, nationality:String, prestige:int, position:String):

	var age_factor:int = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	var factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	
	var physical:Dictionary
	if position == "G":
		physical = {
			"reflexes": min(factor + randi_range(-5, 5), 20),
			"positioning": min(factor + randi_range(-5, 5), 20),
			"kicking": min(factor + randi_range(-5, 5), 20),
			"handling": min(factor + randi_range(-5, 5), 20),
			"diving": min(factor + randi_range(-5, 5), 20),
			"speed": min(factor + randi_range(-5, 5), 20),
		}
	else:
		physical = {
			"reflexes": -1,
			"positioning": -1,
			"kicking": -1,
			"handling": -1,
			"diving": -1,
			"speed": -1,
		}
	return physical


func get_physical(age, nationality, prestige, pos):

	var age_factor:int = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	var pace_factor:int = min(randi_range(9, age_factor), max(prestige, 9))
	var physical_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	
	var physical:Dictionary
	if pos != "G":
		physical = {
			"pace": min(pace_factor + randi_range(-5, 5), 20),
			"acceleration": min(pace_factor + randi_range(-5, 5), 20),
			"stamina": min(physical_factor + randi_range(-5, 5), 20),
			"strength": min(physical_factor + randi_range(-5, 5), 20),
			"agility": min(physical_factor + randi_range(-5, 5), 20),
			"jump": min(physical_factor + randi_range(-5, 5), 20),
		}
	else:
		physical = {
			"pace": -1,
			"acceleration": -1,
			"stamina": -1,
			"strength": -1,
			"agility": -1,
			"jump": -1,
		}
	return physical


func get_technical(age, nationality, prestige, pos):

	var age_factor:int = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	# use also pos i calculation
	var pass_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var shoot_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var technique_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var defense_factor:int = min(randi_range(6, age_factor), max(prestige, 6))

	if pos != "G":
		return {
			"crossing": min(pass_factor + randi_range(-5, 5), 20),
			"passing": min(pass_factor + randi_range(-5, 5), 20),
			"long_passing": min(pass_factor + randi_range(-5, 5), 20),
			"tackling": min(defense_factor + randi_range(-5, 5), 20),
			"heading": min(shoot_factor + randi_range(-5, 5), 20),
			"interception": min(defense_factor + randi_range(-5, 5), 20),
			"shooting": min(shoot_factor + randi_range(-5, 5), 20),
			"long_shooting": min(shoot_factor + randi_range(-5, 5), 20),
			"penalty": min(technique_factor + randi_range(-5, 5), 20),
			"finishing": min(shoot_factor + randi_range(-5, 5), 20),
			"dribbling": min(shoot_factor + randi_range(-5, 5), 20),
			"blocking": min(shoot_factor + randi_range(-5, 5), 20),
		}
	else:
		return {
			"crossing": -1,
			"passing": -1,
			"long_passing": -1,
			"tackling": -1,
			"heading": -1,
			"interception": -1,
			"shooting": -1,
			"long_shooting": -1,
			"penalty": -1,
			"finishing": -1,
			"dribbling": -1,
			"blocking": -1,
		}


func get_mental(age, nationality, prestige, pos):

	var age_factor:int = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	var offensive_factor:int = min(randi_range(6, age_factor), max(prestige, 6))
	var defensive_factor:int = min(randi_range(6, age_factor), max(prestige, 6))

	return {
		"aggression": min(defensive_factor + randi_range(-5, 5), 20),
		"anticipation": min(defensive_factor + randi_range(-5, 5), 20),
		"decisions": min(offensive_factor + randi_range(-5, 5), 20),
		"concentration": min(offensive_factor + randi_range(-5, 5), 20),
		"teamwork": min(offensive_factor + randi_range(-5, 5), 20),
		"vision": min(offensive_factor + randi_range(-5, 5), 20),
		"work_rate": min(offensive_factor + randi_range(-5, 5), 20),
		"offensive_movement": min(offensive_factor + randi_range(-5, 5), 20),
		"marking": min(defensive_factor + randi_range(-5, 5), 20),
	}


func get_price(age, prestige, pos):
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


func get_contract(prestige, position, age):
	var past:int = randi_range(1, 2)
	var future:int = randi_range(1, 3)

	# price_factor = randi_range()

	var contract:Dictionary = {
		"price": 0,
		"money/week": 0,
		"start_date": "2023",
		"end_date": "2023",
		"bonus": {
			"goal": 0,
			"clean_sheet": 0,
			"assist": 0,
			"league_title": 0,
			"nat_cup_title": 0,
			"inter_cup_title": 0,
		},
		"buy_clause": 0,
		"is_on_loan": ""  # if player is on loan, original team name is here
	}
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

	var contract:Dictionary = get_contract(prestige, position, 2020-birth_date.year)
	var potential_growth:int = randi_range(1, 5)

	player.id = player_id
#	player.team = team
	player.price = get_price(2020-birth_date.year, prestige, position)
	player.name = "random.choice(names)"
	player.surname = "random.choice(surnames)"
#	player.birth_date = birth_date
	player.nationality = nationality.split("_")[1]
	player.moral = randi_range(1, 4)  # 1 to 4, 1 low 4 good
#	player.position = position
	player.foot = foots[randi_range(0, len(foots)-1)]
	player.prestige = prestige
	player.form = forms[randi_range(0, len(forms)-1)]
	player.potential_growth
	player.potential_growth = potential_growth
	# _ hidden stats, not visible, just for calcs,
	player.injury_potential = randi_range(1, 20)
	player.loyality = ""  # if player is loay, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
#	player.history = get_history(prestige, position, 2020-birth_date.year, contract, potential_growth)
#	player.contract = contract
	player.nr = nr

#	player["attributes"] = {
#		"goalkeeper": get_goalkeeper_attributes(
#			2020-birth_date.year, nationality, prestige, position),
#		"mental": get_mental(2020-birth_date.year, nationality, prestige, position),
#		"technical": get_technical(2020-birth_date.year, nationality, prestige, position),
#		"physical": get_physical(2020-birth_date.year, nationality, prestige, position),
#	}

	player_id += 1

	return player
	# print(ita_players)


# ita_players = create_players("it_IT")
# esp_players = create_players("es_ES")




#ita_serie_a = assign_players_to_team(ita_serie_a)
#with open('ita_serie_a.json', 'w') as outfile:
#	json.dump(ita_serie_a, outfile)
#print("Serie A done")
#
#ita_serie_b = assign_players_to_team(ita_serie_b)
#with open('ita_serie_b.json', 'w') as outfile:
#	json.dump(ita_serie_b, outfile)
#print("Serie B done")
#
#ita_serie_c = assign_players_to_team(ita_serie_c)
#with open('ita_serie_c.json', 'w') as outfile:
#	json.dump(ita_serie_c, outfile)
#print("Serie C done")

