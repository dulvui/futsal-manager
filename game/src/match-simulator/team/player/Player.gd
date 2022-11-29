extends Node2D

enum Role {DEFENSE, CENTER, ATTACK}

enum Traits {DRIBBLER, PASSER, ROCK, POWER_SHOT} # TODO add more

var role
var stamina

var stats = {
	"goals" : 0,
	"shots" : 0,
	"shots_on_target" : 0,
	"passes" : 0,
	"passes_success" : 0,
	"dribblings" : 0,
	"dribblings_success" : 0,
	"tackling" : 0,
	"tackling_success" : 0,
	"meters_run" : 0,
}

var attributes = {
	'mental': {
		'aggression': 4,
		'aniticipation': 11, 
		'decisions': 13,
		'concentration': 15,
		'teamwork': 7,
		'vision': 11,
		'work_rate': 3,
		'offensive_movement': 3,
		'marking': 17
	},
	'technical': {
		'crossing': 11,
		'passing': 11,
		'long_passing': 12,
		'tackling': 13,
		'heading': 2,
		'interception': 18,
		'shooting': 16,
		'long_shooting': 7,
		'penalty': 1,
		'finishing': 19,
		'dribbling': 16,
		'blocking' : 12
	},
	'physical': {
		'pace': 11,
		'acceleration': 1,
		'agility': 1,
		'jump': 9,
		'stamina': 6,
		'strength': 3
	}
}

var profile = {
	"name" : "Ronaldinho",
	"number" : 10
}

var current_state
var current_sector


func set_up(player) -> void:
	profile["name"] = player["surname"]
	profile["number"] = player["nr"]
	attributes = player["attributes"]
	stamina = attributes["physical"]["stamina"]

			
func update() -> void:
	stamina -= 0.01

func get_attack_attributes(attack) -> int:
	match attack:
		ActionUtil.Attack.SHOOT:
			# check sector and pick long_shoot
			return attributes["technical"]["shooting"]
		ActionUtil.Attack.PASS:
			return attributes["technical"]["passing"] * Constants.PASS_SUCCESS_FACTOR
#		ActionUtil.Attack.CROSS:
#			return attributes["technical"]["crossing"]
		ActionUtil.Attack.DRIBBLE:
			return attributes["technical"]["dribbling"]
#		ActionUtil.Attack.HEADER:
#			return attributes["technical"]["heading"]
		ActionUtil.Attack.RUN:
			var attacker_attributes =  attributes["physical"]["pace"]
			attacker_attributes += attributes["physical"]["acceleration"]
			return attacker_attributes
	# should never happen
	return -1


func get_defense_attributes(attack) -> int:
	match attack:
		ActionUtil.Attack.SHOOT:
			# check sector and pick long_shoot
			return attributes["technical"]["blocking"]
		ActionUtil.Attack.PASS:
			return attributes["technical"]["interception"]
#		ActionUtil.Attack.CROSS:
#			return attributes["technical"]["interception"]
		ActionUtil.Attack.DRIBBLE:
			return attributes["technical"]["tackling"]
#		ActionUtil.Attack.HEADER:
#			return attributes["technical"]["heading"]
		# use player preferences/attirbutes and team tactics pressing or wait
		ActionUtil.Attack.RUN:
			var defender_attributes
			if randi() % 2 == 0: 
#					return Defense.RUN
				defender_attributes = attributes["physical"]["pace"]
				defender_attributes += attributes["physical"]["acceleration"]
			else:
#					return Defense.TACKLE
				defender_attributes = attributes["technical"]["tackling"]
				defender_attributes += attributes["physical"]["pace"]
				
			return defender_attributes
	# should never happen
	return -1
