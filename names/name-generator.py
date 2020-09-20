from faker import Faker
import datetime
import random
import json

br_players = []
esp_players = []
ita_players = []
arg_players = []
rus_players = []
por_players = []
fr_players = []
hol_players = []

# kazakhstan
# iran

# TODO with mots common names from wikipedia
iran_players = []
indoensesia_players = []


# goal keeper, winger, pivot, defender, universal
positions = ["G", "D", "W", "P", "U"]
foots = ["L", "R", "R", "R", "R"]  # 80% right foot
forms = ["INJURED", "RECOVER", "GOOD", "PERFECT"]
# transfer_states = ["TRANSFER","LOAN","FREE_AGENT"]
# nationalyty = ["BR","ES","ARG","IT","FR","IND","GER","POR"]

fake_it = Faker("it_IT")

names = []
surnames = []

# create names
for _ in range(100):
	name_base = fake_it.name_male().replace("Dott. ", "").replace("Sig. ", "")
	names.append(name_base.split()[0])
	surnames.append(name_base.split()[1])


def get_physical(age, nationality, prestige, pos):

    age_factor = 20
    if age > 34:
        age_factor = 54 - age
    elif age < 18:
        age_factor = 16

    pace_factor = min(random.randint(9, age_factor), max(prestige, 9))
    physical_factor = min(random.randint(6, age_factor), max(prestige, 6))

    physical = {
        "acceleration": min(pace_factor + random.randint(-5, 5), 20),
        "pace": min(pace_factor + random.randint(-5, 5), 20),
        "stamina": min(physical_factor + random.randint(-5, 5), 20),
        "strength": min(physical_factor + random.randint(-5, 5), 20),
    }
    return physical


def get_technical(age, nationality, prestige, pos):

    age_factor = 20
    if age > 34:
        age_factor = 54 - age
    elif age < 18:
        age_factor = 16

    # use also pos i calculation
    pass_factor = min(random.randint(6, age_factor), max(prestige, 6))
    shoot_factor = min(random.randint(6, age_factor), max(prestige, 6))
    technique_factor = min(random.randint(6, age_factor), max(prestige, 6))
    defense_factor = min(random.randint(6, age_factor), max(prestige, 6))

    technical = {
        "cross": min(pass_factor + random.randint(-5, 5), 20),
        "pass": min(pass_factor + random.randint(-5, 5), 20),
        "long_pass": min(pass_factor + random.randint(-5, 5), 20),
        "tackling": min(defense_factor + random.randint(-5, 5), 20),
        "heading": min(shoot_factor + random.randint(-5, 5), 20),
        "intercept": min(defense_factor + random.randint(-5, 5), 20),
        "shoot_power": min(shoot_factor + random.randint(-5, 5), 20),
		"shoot_precision": min(shoot_factor + random.randint(-5, 5), 20),
        "dribble": min(technique_factor + random.randint(-5, 5), 20),
        "long_shoot": min(shoot_factor + random.randint(-5, 5), 20),
        "free_kick": min(shoot_factor + random.randint(-5, 5), 20),
        "penalty": min(shoot_factor + random.randint(-5, 5), 20),
        "finishing": min(technique_factor + random.randint(-5, 5), 20),
        "first_touch": min(technique_factor + random.randint(-5, 5), 20),
    }
    return technical


def get_mental(age, nationality, prestige, pos):

    age_factor = 20
    if age > 34:
        age_factor = 54 - age
    elif age < 18:
        age_factor = 16

    offensive_factor = min(random.randint(6, age_factor), max(prestige, 6))
    defensive_factor = min(random.randint(6, age_factor), max(prestige, 6))

    mental = {
        "agressivity": min(defensive_factor + random.randint(-5, 5), 20),
        "anticipation": min(defensive_factor + random.randint(-5, 5), 20),
        "decisions": min(offensive_factor + random.randint(-5, 5), 20),
        "concentration": min(offensive_factor + random.randint(-5, 5), 20),
        "teamwork": min(offensive_factor + random.randint(-5, 5), 20),
        "vision": min(offensive_factor + random.randint(-5, 5), 20),
        "offensive_movement": min(offensive_factor + random.randint(-5, 5), 20),
        "marking": min(defensive_factor + random.randint(-5, 5), 20),
    }
    return mental


def get_price(age, prestige, pos):
    age_factor = min(abs(age - 30), 20)
    pos_factor = 0
    if pos == "G":
        pos_factor = 5
    elif pos == "D":
        pos_factor = 10
    elif pos == "W":
        pos_factor = 15
    else:
        pos_factor = 20

    total_factor = age_factor + pos_factor + prestige

    return random.randint(total_factor-20, total_factor) * 10000


def get_contract(player):
	# check prestige of player and team and make contract, years are random, money depending on prestige etc
    return



def create_player(nationality,position,nr, team):
	global names
	global surnames
	global fake_it
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
    # for _ in range(500):
	birth_date = fake_it.date_time_between(start_date='-45y', end_date='-15y')


	prestige = random.randint(1, 100)
	# to make just a few really good and a few really bad
	if prestige < 30:
		prestige = random.randint(1, 5)
	if prestige > 90:
		prestige = random.randint(15, 20)
	else:
		prestige = random.randint(5, 15)

	# position = positions[random.randint(0, len(positions)-1)]

	player = {
		"team" : team,
		"price": get_price(2020-birth_date.year, prestige, position),
		"name": random.choice(names),
		"surname": random.choice(surnames),
		"birth_date": birth_date.strftime("%d/%m/%Y"),
		"nationality": nationality.split("_")[1],
		"moral": random.randint(1, 4),  # 1 to 4, 1 low 4 good
		"position": position,
		"foot": foots[random.randint(0, len(foots)-1)],
		"prestige": prestige,
		"form": forms[random.randint(0, len(forms)-1)],
		"potential": random.randint(1, 5),  # like stars in FM,
		"_potential_growth": random.randint(1, 5),
		# _ hidden stats, not visible, just for calcs,
		"_injury_potential":  random.randint(1, 20),
		"history": {},
		"mental": get_mental(2020-birth_date.year, nationality, prestige, position),
		"technical": get_technical(2020-birth_date.year, nationality, prestige, position),
		"fisical": get_physical(2020-birth_date.year, nationality, prestige, position),
		"contract": {},
		"nr" : nr
	}
	return player
    # print(ita_players)


# ita_players = create_players("it_IT")
# esp_players = create_players("es_ES")


# create teams
ita_serie_a = [
    {
		"name": "Palermo",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
		},
		"manager" : {
			"name" : "",
			"surname" : "",
			"birthdate" : "",
			"nationality" : "",
		},
		"history": {
			"years" : []
		},
		"formation" : "2-2"
	},
	{
		"name": "C5 Napoli",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Futsal Roma",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 800000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Milano",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Torino",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Genova",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Bologna",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Firenze",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Verona",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Brescia",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Bari",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Parma",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
	{
		"name": "Cagliari",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
			"formation" : "2-2"
	},
	{
		"name": "Lazio",
     	"prestige": 12,
		"budget" : 9000000,
		"salary" : 1000,
		"players" : {
			"active" : [],
			"subs" : []
		},
		"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 5000
			},
		"formation" : "2-2"
	},
]

ita_serie_b = [
    {
		"name": "Palermo",
     	"prestige": 12,
		"budget" : 1000,
		"salary" : 1000
	},
	{
		"name": "C5 Napoli",
     	"prestige": 12
	},
	{
		"name": "Futsal Roma",
     	"prestige": 12
	},
	{
		"name": "Milano",
     	"prestige": 12
	},
	{
		"name": "Torino",
     	"prestige": 12
	},
	{
		"name": "Genova",
     	"prestige": 12
	},
	{
		"name": "Bologna",
     	"prestige": 12
	},
	{
		"name": "Firenze",
     	"prestige": 12
	},
	{
		"name": "Verona",
     	"prestige": 12
	},
	{
		"name": "Brescia",
     	"prestige": 12
	},
	{
		"name": "Bari",
     	"prestige": 12
	},
	{
		"name": "Parma",
     	"prestige": 12
	},
	{
		"name": "Cagliari",
     	"prestige": 12
	},
	{
		"name": "Lazio",
     	"prestige": 12
	},
]

ita_serie_c = [
    {
		"name": "Palermo",
     	"prestige": 12,
		"budget" : 1000,
		"salary" : 1000
	},
	{
		"name": "C5 Napoli",
     	"prestige": 12
	},
	{
		"name": "Futsal Roma",
     	"prestige": 12
	},
	{
		"name": "Milano",
     	"prestige": 12
	},
	{
		"name": "Torino",
     	"prestige": 12
	},
	{
		"name": "Genova",
     	"prestige": 12
	},
	{
		"name": "Bologna",
     	"prestige": 12
	},
	{
		"name": "Firenze",
     	"prestige": 12
	},
	{
		"name": "Verona",
     	"prestige": 12
	},
	{
		"name": "Brescia",
     	"prestige": 12
	},
	{
		"name": "Bari",
     	"prestige": 12
	},
	{
		"name": "Parma",
     	"prestige": 12
	},
	{
		"name": "Cagliari",
     	"prestige": 12
	},
	{
		"name": "Lazio",
     	"prestige": 12
	},
]


#fill ita serie a teams with players
for team in ita_serie_a:
	nr = 1

	#G
	g1 = create_player("it_IT","G",nr, team["name"])
	nr += 1
	team["players"]["active"].append(g1)
	for _ in range(0,random.randint(3,5)):
		g2 = create_player("it_IT","G",nr, team["name"])
		team["players"]["subs"].append(g2)
		nr += 1
	#D
	d1 = create_player("it_IT","D",nr, team["name"])
	team["players"]["active"].append(d1)
	nr += 1
	for _ in range(0,random.randint(3,5)):
		d2 = create_player("it_IT","D",nr, team["name"])
		team["players"]["subs"].append(d2)
		nr += 1
	#WL
	wl1 = create_player("it_IT","WL",nr, team["name"])
	team["players"]["active"].append(wl1)
	nr += 1
	for _ in range(0,random.randint(2,4)):
		wl2 = create_player("it_IT","WL",nr, team["name"])
		team["players"]["subs"].append(wl2)
		nr += 1

	#WR
	wr1 = create_player("it_IT","WR",nr, team["name"])
	team["players"]["active"].append(wr1)
	nr += 1
	for _ in range(0,random.randint(2,4)):
		wl2 = create_player("it_IT","WR",nr, team["name"])
		team["players"]["subs"].append(wl2)
		nr += 1
	#P
	p1 = create_player("it_IT","P",nr, team["name"])
	team["players"]["active"].append(p1)
	nr += 1

	for _ in range(0,random.randint(2,4)):
		p2 = create_player("it_IT","P",nr, team["name"])
		team["players"]["subs"].append(p2)
		nr += 1
	
	#U
	for _ in range(0,random.randint(1,2)):
		u = create_player("it_IT","U",nr, team["name"])
		team["players"]["subs"].append(u)
		nr += 1


with open('ita_serie_a.json', 'w') as outfile:
    json.dump(ita_serie_a, outfile)
