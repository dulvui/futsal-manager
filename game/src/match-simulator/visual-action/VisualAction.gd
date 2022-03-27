extends Node2D

onready var attacker = $Attacker
onready var attacker2 = $Attacker2
onready var timer = $Timer
onready var ball = $Ball

# Called when the node enters the scene tree for the first time.
func _ready():
	attacker.set_up(null)
	attacker2.set_up(null)
	timer.start()
	

func set_up():
	pass

func _on_Timer_timeout():
#	attacker.velocity = 0.1
	attacker2.velocity = 0.1
	
	attacker2.disable_ball_controll()
	ball.move(attacker.global_position)
#	ball.move($Field/Goal/Center.global_position)

