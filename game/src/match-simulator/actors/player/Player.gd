extends Node2D

const SimulatorPlayer = preload("res://src/match-simulator/actors/player/SimulatorPlayer.gd")


export var color = Color.rebeccapurple
export var nr:int = 1

enum states {CHASE,KICK,WAIT,HOME,SUPPORT} 
enum roles {DC,DL,DR,CL,CR,CC,AL,AR,AC} 

var player
var formation

var state
var role

var home_region # gets assigned depending on role and formation + tactics
var kick_off_region # kick in, corner etc??

var dinstance_to_ball
var target

var has_ball # is function is_controlling player in simple soccer
var ball

var velocity = 3

func _ready():
	$Control/ColorRect.color = color
	$Control/ShirtNumber.text = str(nr)
	

var has_ball_now = false

func set_up(at_home, _player, _role, _formation,_ball):
	player = _player
	formation = _formation
	role = _role
	ball = _ball
	nr = player["nr"]
#	$Control/ColorRect.color = Color.aliceblue
#	$Control/ShirtNumber.text = str(nr)
	
	target = ball.global_position
	
	if at_home:
		position = Vector2(formation["positions"][role][0],formation["positions"][role][1])
	else:
		position = Vector2(600 - formation["positions"][role][0],formation["positions"][role][1])
	#place player to homeregion


func chase():
	state = states.CHASE

func is_ahead_of_attacker():
	pass
	
func at_target():
	pass
	
func at_support_spot():
	pass
	
# could be moved to team code
func is_closest_to_ball():
	pass
	
func in_hot_region():
	pass
