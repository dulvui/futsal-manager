extends Node2D

enum Role {DEFENSE, CENTER, ATTACK}

enum Traits {DRIBBLER, PASSER, ROCK, POWER_SHOT} # TODO add more

var role

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
		'agressivity': 4,
		'aniticipation': 11, 
		'decisions': 13,
		'concentration': 15,
		'teamwork': 7,
		'vision': 11,
		'work_rate': 3,
		'offensive_movement': 3,
		'defensive_movement': 17
	},
	'technical': {
		'crossing': 11,
		'passing': 11,
		'long_passing': 12,
		'tackling': 13,
		'corners': 8,
		'heading': 2,
		'interception': 18,
		'marking': 11,
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
		'balance': 4,
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


func set_up(player):
	profile["name"] = player["surname"]
	profile["number"] = player["nr"]
	

			
func update():
	# reduce stamina
	# increase stats
	pass
