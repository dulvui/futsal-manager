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

	
	# create teams
var ita_serie_a:Array = [
	{
		"name": "Acqua&Sapone C5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Tocha Stadium",
					"capacity": 800
		},
		"manager": {
			"name": "",
					"surname": "",
					"birthdate": "",
					"nationality": "",
		},
		"history": {
			"years": []
		},
		"formation": "2-2"
	},
	{
		"name": "Pesaro C5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Palazzetto dello Sport PalaCercola",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Real Rieti",
		"prestige": 12,
				"budget": 9000000,
				"salary_budget": 800000,
				"players": {
					"active": [],
					"subs": []
				},
		"stadium": {
					"name": "Estadio Central",
					"capacity": 5000
				},
		"formation": "2-2"
	},
	{
		"name": "Meta Catania",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Napoli Calcio A 5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Feldi Eboli",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Came Dosson C5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Maritime Futsal Augusta",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Civitella Colormax C5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Lazio Calcio A 5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Latina Calcio A 5",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Real Futsal Arzignano",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Cagliari",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Lazio",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
]

var ita_serie_b:Array = [
	{
		"name": "Palermo B",
		"prestige": 12,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "C5 Napoli B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Futsal Roma B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Milano B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Torino B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Genova B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Bologna B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Firenze B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Verona B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Brescia B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Bari B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Parma B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Cagliari B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Lazio B",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
]

var ita_serie_c:Array = [
	{
		"name": "Palermo C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "C5 Napoli C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Futsal Roma C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Milano C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Torino C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Genova C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Bologna C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Firenze C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Verona C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Brescia C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Bari C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Parma C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Cagliari C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
	{
		"name": "Lazio C",
		"prestige": 8,
		"budget": 9000000,
		"salary_budget": 1000,
		"players": {
			"active": [],
			"subs": []
		},
		"stadium": {
			"name": "Estadio Central",
					"capacity": 5000
		},
		"formation": "2-2"
	},
]

func _run():
	print("Generate players...")
	var test = assign_players_to_team(ita_serie_a)
	print(test)
	print("Done.")



func assign_players_to_team(teams):
	var id:int = 1
	# fill ita serie a teams with players
	for team in teams:
		
		team["id"] = id
		id += 1

		var nr:int = 1
		# G
		var g1 = create_player("it_IT", "G", nr, team["name"])
		nr += 1
		team["players"]["active"].append(g1)
		for i in randi_range(3, 5):
			var g2 = create_player("it_IT", "G", nr, team["name"])
			team["players"]["subs"].append(g2)
			nr += 1
		# D
		var d1 = create_player("it_IT", "D", nr, team["name"])
		team["players"]["active"].append(d1)
		nr += 1
		for i in randi_range(3, 5):
			var d2 = create_player("it_IT", "D", nr, team["name"])
			team["players"]["subs"].append(d2)
			nr += 1
		# WL
		var wl1 = create_player("it_IT", "WL", nr, team["name"])
		team["players"]["active"].append(wl1)
		nr += 1
		for i in randi_range(2, 4):
			var wl2 = create_player("it_IT", "WL", nr, team["name"])
			team["players"]["subs"].append(wl2)
			nr += 1

		# WR
		var wr1 = create_player("it_IT", "WR", nr, team["name"])
		team["players"]["active"].append(wr1)
		nr += 1
		for i in randi_range(2, 4):
			var wl2 = create_player("it_IT", "WR", nr, team["name"])
			team["players"]["subs"].append(wl2)
			nr += 1
		# P
		var p1 = create_player("it_IT", "P", nr, team["name"])
		team["players"]["active"].append(p1)
		nr += 1

		for i in randi_range(2, 4):
			var p2 = create_player("it_IT", "P", nr, team["name"])
			team["players"]["subs"].append(p2)
			nr += 1

		# U
		for i in randi_range(2, 4):
			var u = create_player("it_IT", "U", nr, team["name"])
			team["players"]["subs"].append(u)
			nr += 1

	return teams

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


func create_player(nationality, position, nr, team):
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

	var player:Dictionary = {
		"id": player_id,
		"team": team,
		"price": get_price(2020-birth_date.year, prestige, position),
		"name": "random.choice(names)",
		"surname": "random.choice(surnames)",
		"birth_date": birth_date,
		"nationality": nationality.split("_")[1],
		"moral": randi_range(1, 4),  # 1 to 4, 1 low 4 good
		"position": position,
		"foot": foots[randi_range(0, len(foots)-1)],
		"prestige": prestige,
		"form": forms[randi_range(0, len(forms)-1)],
		"_potential_growth": potential_growth,
		# _ hidden stats, not visible, just for calcs,
		"_injury_potential":  randi_range(1, 20),
		"_loyality": "",  # if player is loay, he doesnt want to leave the club, otherwise he leaves esaily, also on its own
		"history": get_history(prestige, position, 2020-birth_date.year, contract, potential_growth),
		"contract": contract,
		"nr": nr
	}

	player["attributes"] = {
		"goalkeeper": get_goalkeeper_attributes(
			2020-birth_date.year, nationality, prestige, position),
		"mental": get_mental(2020-birth_date.year, nationality, prestige, position),
		"technical": get_technical(2020-birth_date.year, nationality, prestige, position),
		"physical": get_physical(2020-birth_date.year, nationality, prestige, position),
	}

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

