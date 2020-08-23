extends KinematicBody2D

export (String, "G", "D", "WL", "WR", "P") var pos = "G"

var stats = {}
var shirtnumber = 1
var surname = ""

var goals = 0
var shots = 0
var shots_on_target = 0
var passes = 0
var passes_success = 0
var dribblings = 0
var dribblings_success = 0
var tackling = 0
var tackling_success = 0
var meters_run = 0


onready var ball = get_parent().get_parent().get_node("Ball")

export var shirt_number = "1"
export var shirt_color = Color.red

var has_ball = false #probably detects when ball enters Ball detector

onready var eyes = $Eyes

func _ready():
	$Control/ShirtNumber.text = shirt_number
	$Control/ColorRect.color = shirt_color

func set_up(player):
	eyes.cast_to(0,player["visiion"] * 10)

func _physics_process(delta):
	if pos != "G":
		var direction = (ball.global_position - global_position).normalized()
		var distance_to_player = global_position.distance_to(ball.global_position)
		move_and_slide(direction *0.4 * distance_to_player)
	
	
#	print("pla")
	look_at(ball.global_position)
#	print(ball.global_position)


func update():
	if has_ball:
		pass
		#move forwards, if playerdetectore detects enemy, pass, dribble, move back or shoot
		#dependig on tactic and stats of player
	else:
		#check where ball is, if near go to ball, else mark player or stay in position
		pass

# move to player or ball, whatever closer is.
# special movements: cornerns, penlaties, free kicks, kick off, rimessa
func move():
	pass
	

func pass_ball():
	pass
	
	

# so player can hear other players, when no seeing, depends on teamwork if players shout or not
func hear():
	pass
