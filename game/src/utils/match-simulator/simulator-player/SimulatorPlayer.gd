extends Node

enum roles {G,DC,DL,DR,CL,CC,CR,PL,PC,PR}

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
var player

# simple soccer
var role

var steering # velocity or so

var home_region
var kick_off_region
var corner_region
var free_kick_region
var penalty_region
var kick_in_region

var distance_to_ball

var vertex_buffers = [] # ???????

onready var ball = get_parent().get_node("Ball")

func _ready():
	add_to_group("simulator_player")

func set_up(player, role, formation):
	pass

func kick_off():
	pass

func update():
	pass

func got_to_support_spot():
	pass
	
func is_ahead_of_attacker():
	pass
	
func at_target():
	pass
	
func at_support_spot():
	pass
	
func is_closest_to_ball():
	pass
