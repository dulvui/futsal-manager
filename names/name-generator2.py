from faker import Faker
import datetime
import random

ita_players = []
por_players = []
esp_players = []
br_players = []
fr_players = []
arg_players = []
rus_players = []
hol_players = []

#TODO with mots common names from wikipedia
iran_players = []
indoensesia_players = []


positions = ["G","D","W","P","U"] # goal keeper, winger, pivot, defender, universal
foots = ["L","R","R","R","R"] # 80% right foot
forms = ["INJURED","RECOVER","GOOD","PERFECT"]
# transfer_states = ["TRANSFER","LOAN","FREE_AGENT"]
# nationalyty = ["BR","ES","ARG","IT","FR","IND","GER","POR"]

def get_physical(age,nationality):

	factor = 20
	if age > 34:
		factor = 54 - age
	elif age < 18:
		factor = 16

	physical = {
		"acceleration" : random.randint(1,factor),
		"agility" : random.randint(1,factor),
		"balance" : random.randint(1,factor),
		"jump" : random.randint(1,factor),
		"pace" : random.randint(1,factor),
		"stamina" : random.randint(1,factor),
		"strength" : random.randint(1,factor),
	}
	return physical

def get_technical(age,nationality):

	factor = 20
	if age > 34:
		factor = 54 - age
	elif age < 18:
		factor = 16

	pass_factor = max(random.randint(1,factor),4)

	technical = {
			"crossing" : min(pass_factor + random.randint(-3,3),20),
			"pass" : min(pass_factor + random.randint(-3,3),20),
			"long_pass" : min(pass_factor + random.randint(-3,3),20),
			"tackling" : random.randint(1,20),
			"heading" : random.randint(1,20),
			"interception" : random.randint(1,20),
			"marking" : random.randint(1,20),
			"shoot" : random.randint(1,20),
			"dribble" : random.randint(1,20),
			"long_shoot" : random.randint(1,20),
			"free_kick" : random.randint(1,20),
			"penalty" : random.randint(1,20),
			"finishing" : random.randint(1,20),
			"technique" : random.randint(1,20),
			"first_touch" : random.randint(1,20),
 		}
	return technical

fake_it = Faker('it_IT')

for _ in range(100):
	name_base = fake_it.name_male().replace("Dott. ","").replace("Sig. ","")
	for _ in range(5):
		birth_date = fake_it.date_time_between(start_date='-45y', end_date='-15y')

		stats = {
			"mental" :{
				"agressivity" : random.randint(1,20),
				"aniticipation" : random.randint(1,20),
				"decisions" : random.randint(1,20),
				"concentration" : random.randint(1,20),
				"teamwork" : random.randint(1,20),
				"vision" : random.randint(1,20),
				"work_rate" : random.randint(1,20),
				"offensive_movement" : random.randint(1,20),
				"defensive_movement" : random.randint(1,20),
			},
			"technial" : get_technical(2020-birth_date.year,"IT"),
			"physycal" : get_physical(2020-birth_date.year,"IT")
		}

		player = {
			"name":fake_it.name_male().replace("Dott. ","").replace("Sig. ",""),
			"surname":name_base.split()[1],
			"birth_date": birth_date.strftime("%d/%m/%Y"),
			"nationality" : "IT",
			"moral" : random.randint(1, 4), # 1 to 4, 1 low 4 good
			"position" : positions[random.randint(0,len(positions)-1)],
			"foot" : foots[random.randint(0,len(foots)-1)],
			"prestige" : random.randint(1,20),
			"form" : forms[random.randint(0,len(forms)-1)],
			"potential" : random.randint(1,5), # like stars in FM,
			"transfer_state" : "NO",
			"_potential_growth" : random.randint(1,5),
			"_injury_potential" :  random.randint(1,20), # _ hidden stats, not visible, just for calcs,
			"history" : {},
			"stats" : stats,
			"team" : "Free Agent"
		}
		ita_players.append(player)





for _ in range(200):
	birth_date = fake_it.date_time_between(start_date='-45y', end_date='-15y')
	stats = {
		"mental" :{
			"agressivity" : random.randint(1,20),
			"aniticipation" : random.randint(1,20),
			"decisions" : random.randint(1,20),
			"concentration" : random.randint(1,20),
			"teamwork" : random.randint(1,20),
			"vision" : random.randint(1,20),
			"work_rate" : random.randint(1,20),
			"offensive_movement" : random.randint(1,20),
			"defensive_movement" : random.randint(1,20),
		},
		"technical" : get_technical(2020-birth_date.year,"IT"),
		"physycal" : get_physical(2020-birth_date.year,"IT")
	}

	name_base = fake_it.name_male().replace("Dott. ","").replace("Sig. ","")

	player = {
		"name":name_base.split()[0],
		"surname":name_base.split()[1],
		"birth_date": birth_date.strftime("%m/%d/%Y"),
		"nationality" : "IT",
		"moral" : random.randint(1, 4), # 1 to 4, 1 low 4 good
		"position" : positions[random.randint(0,len(positions)-1)],
		"foot" : foots[random.randint(0,len(foots)-1)],
		"prestige" : random.randint(1,20),
		"form" : forms[random.randint(0,len(forms)-1)],
		"potential" : random.randint(1,5), # like stars in FM,
		"transfer_state" : "NO",
		"_potential_growth" : random.randint(1,5),
		"_injury_potential" :  random.randint(1,20), # _ hidden stats, not visible, just for calcs,
		"history" : {},
		"stats" : stats,
		"team" : "Free Agent"
	}
	ita_players.append(player)

print(ita_players)
# fake_br = Faker('pt_BR')
# for _ in range(500):
# 	print(fake_br.name_male())
# #	print


# fake_es = Faker('es_ES')
# for _ in range(500):
# 	print(fake_es.name_male())
# #	print

# fake_fr = Faker('fr_FR')
# for _ in range(500):
# 	print(fake_fr.name_male())
# #	print
