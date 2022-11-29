extends Node2D

enum Attack {KICK, PASS, WAIT}
enum Defend {SAFE, WAIT}
enum State {ATTACK, DEFEND, PENALTY, FREE_KICK, CORNER}

var profile = {
	"name" : "Ronaldinho",
	"number" : 10
}

var stats = {
	"passes" : 0,
	"passes_success" : 0,
	"safes" : 0
}

# update to goalkeeper attributes
var attributes = {
	'reflexes': 4,
	'positioning': 11,
	'kicking': 13,
	'handling': 15,
	'diving': 7,
	'speed' : 7
}

var current_state

func set_up(player) -> void:
	profile["name"] = player["surname"]
	profile["number"] = player["nr"]
	attributes = player["attributes"]
