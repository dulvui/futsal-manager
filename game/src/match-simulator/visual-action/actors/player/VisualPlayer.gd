extends KinematicBody2D

export var color = Color.rebeccapurple
export var nr:int = 1

enum states {CHASE,KICK,WAIT,HOME,SUPPORT}

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

var destination = Vector2(0,200)

var profile

var state

var dinstance_to_ball
var target

var velocity = 1

func _ready():
	$Control/ColorRect.color = color
	if profile:
		$Control/ShirtNumber.text = str(profile["nr"])

func set_up(_profile):
	profile = _profile
	
func _physics_process(delta):
	move_and_slide(destination * velocity, Vector2.ZERO)

func disable_ball_controll():
	$BallControl/CollisionPolygon2D.disabled = true
	
func enable_ball_controll():
	$BallControl/CollisionPolygon2D.enabled = true
