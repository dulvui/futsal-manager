extends KinematicBody2D

const SimulatorPlayer = preload("res://src/utils/match-simulator/actors/player/SimulatorPlayer.gd")


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
var acceleration
var direction

var joint

var at_home

func _ready():
	$Control/ColorRect.color = color
	$Control/ShirtNumber.text = str(nr)
	
	joint = $CollisionShape2D/DampedSpringJoint2D

var has_ball_now = false
	
func _physics_process(delta):
	if ball and state == states.CHASE:
		dinstance_to_ball = global_position.distance_to(target)
		direction = (target - global_position).normalized()
		if not has_ball_now:
			if dinstance_to_ball < 80:
				joint.add_child(ball)
				joint.node_b = ball.get_path()
				has_ball_now = true
		move_and_slide(velocity * direction * dinstance_to_ball)
		target = ball.global_position

func set_up(is_at_home,new_player, new_role, new_formation,new_ball):
	at_home = is_at_home
#	color = teamcolor
	player = new_player
	formation = new_formation
	role = new_role
	ball = new_ball
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
