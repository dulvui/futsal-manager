from faker import Faker
import datetime
import random

br_players = []
esp_players = []
ita_players = []
arg_players = []
rus_players = []
por_players = []
fr_players = []
hol_players = []

#kazakhstan
#iran

#TODO with mots common names from wikipedia
iran_players = []
indoensesia_players = []


positions = ["G","D","W","P","U"] # goal keeper, winger, pivot, defender, universal
foots = ["L","R","R","R","R"] # 80% right foot
forms = ["INJURED","RECOVER","GOOD","PERFECT"]
# transfer_states = ["TRANSFER","LOAN","FREE_AGENT"]
# nationalyty = ["BR","ES","ARG","IT","FR","IND","GER","POR"]

def get_physical(age,nationality,prestige,pos):

	age_factor = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	pace_factor = min(random.randint(6,age_factor),max(prestige,6))
	physical_factor = min(random.randint(6,age_factor),max(prestige,6))


	physical = {
		"acceleration" : min(pace_factor + random.randint(-5,5),20),
		"agility" : min(pace_factor + random.randint(-5,5),20),
		"balance" : min(physical_factor + random.randint(-5,5),20),
		"jump" : min(physical_factor + random.randint(-5,5),20),
		"pace" : min(pace_factor + random.randint(-5,5),20),
		"stamina" : min(physical_factor + random.randint(-5,5),20),
		"strength" : min(physical_factor + random.randint(-5,5),20),
	}
	return physical

def get_technical(age,nationality,prestige,pos):

	age_factor = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	# use also pos i calculation
	pass_factor = min(random.randint(6,age_factor),max(prestige,6))
	shoot_factor = min(random.randint(6,age_factor),max(prestige,6))
	technique_factor = min(random.randint(6,age_factor),max(prestige,6))
	defense_factor = min(random.randint(6,age_factor),max(prestige,6)) 

	technical = {
			"crossing" : min(pass_factor + random.randint(-5,5),20),
			"pass" : min(pass_factor + random.randint(-5,5),20),
			"long_pass" : min(pass_factor + random.randint(-5,5),20),
			"tackling" : min(defense_factor + random.randint(-5,5),20),
			"heading" : min(shoot_factor + random.randint(-5,5),20),
			"interception" : min(defense_factor + random.randint(-5,5),20),
			"marking" : min(defense_factor + random.randint(-5,5),20),
			"shoot" : min(shoot_factor + random.randint(-5,5),20),
			"dribble" : min(technique_factor + random.randint(-5,5),20),
			"long_shoot" : min(shoot_factor + random.randint(-5,5),20),
			"free_kick" : min(shoot_factor + random.randint(-5,5),20),
			"penalty" : min(shoot_factor + random.randint(-5,5),20),
			"finishing" : min(technique_factor + random.randint(-5,5),20),
			"technique" : min(technique_factor + random.randint(-5,5),20),
			"first_touch" : min(technique_factor + random.randint(-5,5),20),
 		}
	return technical

def get_mental(age,nationality,prestige,pos):

	age_factor = 20
	if age > 34:
		age_factor = 54 - age
	elif age < 18:
		age_factor = 16

	offensive_factor = min(random.randint(6,age_factor),max(prestige,6))
	defensive_factor = min(random.randint(6,age_factor),max(prestige,6))


	mental = {
			"agressivity" : min(defensive_factor + random.randint(-5,5),20),
			"aniticipation" : min(defensive_factor + random.randint(-5,5),20),
			"decisions" : min(offensive_factor + random.randint(-5,5),20),
			"concentration" : min(offensive_factor + random.randint(-5,5),20),
			"teamwork" : min(offensive_factor + random.randint(-5,5),20),
			"vision" : min(offensive_factor + random.randint(-5,5),20),
			"work_rate" : min(offensive_factor + random.randint(-5,5),20),
			"offensive_movement" : min(offensive_factor + random.randint(-5,5),20),
			"defensive_movement" : min(defensive_factor + random.randint(-5,5),20),
		}
	return mental

#ITALY
fake_it = Faker('it_IT')

ita_names = []
ita_surnames = []

#create names
for _ in range(100):
	name_base = fake_it.name_male().replace("Dott. ","").replace("Sig. ","")
	ita_names.append(name_base.split()[0])
	ita_surnames.append(name_base.split()[1])

#create players
for _ in range(500):
	birth_date = fake_it.date_time_between(start_date='-45y', end_date='-15y')

	prestige = random.randint(1,100)
	#to make just a few really good and a few really bad
	if prestige < 30:
		prestige = random.randint(1,5)
	if prestige > 90:
		prestige = random.randint(15,20)
	else:
		prestige = random.randint(5,15)

	position = positions[random.randint(0,len(positions)-1)]

	player = {
		"name":random.choice(ita_names),
		"surname":random.choice(ita_surnames),
		"birth_date": birth_date.strftime("%d/%m/%Y"),
		"nationality" : "IT",
		"moral" : random.randint(1, 4), # 1 to 4, 1 low 4 good
		"position" : position,
		"foot" : foots[random.randint(0,len(foots)-1)],
		"prestige" : prestige,
		"form" : forms[random.randint(0,len(forms)-1)],
		"potential" : random.randint(1,5), # like stars in FM,
		"transfer_state" : "NO",
		"_potential_growth" : random.randint(1,5),
		"_injury_potential" :  random.randint(1,20), # _ hidden stats, not visible, just for calcs,
		"history" : {},
		"mental" : get_mental(2020-birth_date.year,"IT",prestige,position),
		"technical" : get_technical(2020-birth_date.year,"IT",prestige,position),
		"physycal" : get_physical(2020-birth_date.year,"IT",prestige,position),
		"contract" : {}
	}
	ita_players.append(player)

print(ita_players)

# create teams