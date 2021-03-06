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

team_id = 15  # last id of serie-a team is 14
player_id = 1


# create names
for _ in range(100):
    name_base = fake_it.name_male().replace("Dott. ", "").replace("Sig. ", "")
    names.append(name_base.split()[0])
    surnames.append(name_base.split()[1])


def get_goalkeeper_attributes(age, nationality, prestige, position):

    age_factor = 20
    if age > 34:
        age_factor = 54 - age
    elif age < 18:
        age_factor = 16

    factor = min(random.randint(6, age_factor), max(prestige, 6))

    if position == "G":
        physical = {
            "reflexes": min(factor + random.randint(-5, 5), 20),
            "positioning": min(factor + random.randint(-5, 5), 20),
            "kicking": min(factor + random.randint(-5, 5), 20),
            "handling": min(factor + random.randint(-5, 5), 20),
            "diving": min(factor + random.randint(-5, 5), 20),
            "speed": min(factor + random.randint(-5, 5), 20),
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


def get_physical(age, nationality, prestige, pos):

    age_factor = 20
    if age > 34:
        age_factor = 54 - age
    elif age < 18:
        age_factor = 16

    pace_factor = min(random.randint(9, age_factor), max(prestige, 9))
    physical_factor = min(random.randint(6, age_factor), max(prestige, 6))

    if pos != "G":
        physical = {
            "pace": min(pace_factor + random.randint(-5, 5), 20),
            "acceleration": min(pace_factor + random.randint(-5, 5), 20),
            "stamina": min(physical_factor + random.randint(-5, 5), 20),
            "strength": min(physical_factor + random.randint(-5, 5), 20),
            "agility": min(physical_factor + random.randint(-5, 5), 20),
            "jump": min(physical_factor + random.randint(-5, 5), 20),
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

    if pos != "G":
        technical = {
            "crossing": min(pass_factor + random.randint(-5, 5), 20),
            "passing": min(pass_factor + random.randint(-5, 5), 20),
            "long_passing": min(pass_factor + random.randint(-5, 5), 20),
            "tackling": min(defense_factor + random.randint(-5, 5), 20),
            "heading": min(shoot_factor + random.randint(-5, 5), 20),
            "interception": min(defense_factor + random.randint(-5, 5), 20),
            "shooting": min(shoot_factor + random.randint(-5, 5), 20),
            "long_shooting": min(shoot_factor + random.randint(-5, 5), 20),
            "penalty": min(technique_factor + random.randint(-5, 5), 20),
            "finishing": min(shoot_factor + random.randint(-5, 5), 20),
            "dribbling": min(shoot_factor + random.randint(-5, 5), 20),
            "blocking": min(shoot_factor + random.randint(-5, 5), 20),
        }
    else:
        technical = {
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
        "aggression": min(defensive_factor + random.randint(-5, 5), 20),
        "anticipation": min(defensive_factor + random.randint(-5, 5), 20),
        "decisions": min(offensive_factor + random.randint(-5, 5), 20),
        "concentration": min(offensive_factor + random.randint(-5, 5), 20),
        "teamwork": min(offensive_factor + random.randint(-5, 5), 20),
        "vision": min(offensive_factor + random.randint(-5, 5), 20),
        "work_rate": min(offensive_factor + random.randint(-5, 5), 20),
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


def get_contract(prestige, position, age):
    global fake_it

    past = random.randint(1, 2)
    future = random.randint(1, 3)

    # price_factor = random.randint()

    contract = {
        "price": 0,
        "money/week": 0,
        "start_date": fake_it.date_time_between(start_date='-' + str(past) + 'y', end_date='-1y').strftime("%d/%m/%Y"),
        "end_date": fake_it.date_time_between(start_date='+1y', end_date='+' + str(future) + 'y').strftime("%d/%m/%Y"),
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


def get_history(prestige, position, age, contract, potential_growth):
    global fake_it

    past = random.randint(1, 2)
    future = random.randint(1, 3)

    # price_factor = random.randint()

    # look at years in contract, so before he played in other club
    # look at potential growth and stats of player and increase price over years
    # save also price evolution

    history = [
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


def create_player(nationality, position, nr, team):
    global names
    global surnames
    global fake_it
    global player_id
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

    contract = get_contract(prestige, position, 2020-birth_date.year)
    potential_growth = random.randint(1, 5)

    player = {
        "id": player_id,
        "team": team,
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
        "_potential_growth": potential_growth,
        # _ hidden stats, not visible, just for calcs,
        "_injury_potential":  random.randint(1, 20),
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


# create teams
ita_serie_a = [
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

ita_serie_b = [
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

ita_serie_c = [
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


def assign_players_to_team(teams):
    id = 1
    # fill ita serie a teams with players
    for team in teams:
        
        team["id"] = id
        id += 1

        nr = 1
        # G
        g1 = create_player("it_IT", "G", nr, team["name"])
        nr += 1
        team["players"]["active"].append(g1)
        for _ in range(0, random.randint(3, 5)):
            g2 = create_player("it_IT", "G", nr, team["name"])
            team["players"]["subs"].append(g2)
            nr += 1
        # D
        d1 = create_player("it_IT", "D", nr, team["name"])
        team["players"]["active"].append(d1)
        nr += 1
        for _ in range(0, random.randint(3, 5)):
            d2 = create_player("it_IT", "D", nr, team["name"])
            team["players"]["subs"].append(d2)
            nr += 1
        # WL
        wl1 = create_player("it_IT", "WL", nr, team["name"])
        team["players"]["active"].append(wl1)
        nr += 1
        for _ in range(0, random.randint(2, 4)):
            wl2 = create_player("it_IT", "WL", nr, team["name"])
            team["players"]["subs"].append(wl2)
            nr += 1

        # WR
        wr1 = create_player("it_IT", "WR", nr, team["name"])
        team["players"]["active"].append(wr1)
        nr += 1
        for _ in range(0, random.randint(2, 4)):
            wl2 = create_player("it_IT", "WR", nr, team["name"])
            team["players"]["subs"].append(wl2)
            nr += 1
        # P
        p1 = create_player("it_IT", "P", nr, team["name"])
        team["players"]["active"].append(p1)
        nr += 1

        for _ in range(0, random.randint(2, 4)):
            p2 = create_player("it_IT", "P", nr, team["name"])
            team["players"]["subs"].append(p2)
            nr += 1

        # U
        for _ in range(0, random.randint(1, 2)):
            u = create_player("it_IT", "U", nr, team["name"])
            team["players"]["subs"].append(u)
            nr += 1

    return teams

ita_serie_a = assign_players_to_team(ita_serie_a)
with open('ita_serie_a.json', 'w') as outfile:
    json.dump(ita_serie_a, outfile)
print("Serie A done")

ita_serie_b = assign_players_to_team(ita_serie_b)
with open('ita_serie_b.json', 'w') as outfile:
    json.dump(ita_serie_b, outfile)
print("Serie B done")

ita_serie_c = assign_players_to_team(ita_serie_c)
with open('ita_serie_c.json', 'w') as outfile:
    json.dump(ita_serie_c, outfile)
print("Serie C done")
