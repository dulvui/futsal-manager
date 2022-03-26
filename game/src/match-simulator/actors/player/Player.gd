extends Node2D

export var color = Color.rebeccapurple
export var nr:int = 1

enum states {CHASE,KICK,WAIT,HOME,SUPPORT} 
enum roles {DC,DL,DR,CL,CR,CC,AL,AR,AC} 

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

var profile
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
	$Control/ShirtNumber.text = str(profile["nr"])
	

var has_ball_now = false

func set_up(at_home, _profile, _role, _formation,_ball):
	profile = _profile
	formation = _formation
	role = _role
	ball = _ball
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
