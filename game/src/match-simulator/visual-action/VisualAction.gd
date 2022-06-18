extends Node2D

const VisualPlayer = preload("res://src/match-simulator/visual-action/actors/player/VisualPlayer.tscn")

const MAX_POSITIONS = 10
const MIN_POSITIONS = 2

const MAX_PLAYERS = 5
const MIN_PLAYERS = 2

const WIDTH = 500
const HEIGHT = 800

onready var attacker = $Attacker
onready var attacker2 = $Attacker2
onready var timer = $Timer
onready var ball = $Ball

# shoot is final action, happens always
enum ACTIONS {PASS, RUN, DRIBBLE} 

# list of random positions on the field, where the ball and at least one player moves
var actions = []

var players = []


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	_player_setup()
	_actions_setup()
	
func _actions_setup():
	for i in rand_range(MIN_POSITIONS, MAX_POSITIONS):
		
		# make positons move towards goal
		# with +/- tolerance, so that i can also move a bit backwards
		var action = {
			"position": Vector2(randi() % WIDTH, randi() % HEIGHT),
			"action": ACTIONS.values()[randi() % ACTIONS.size()]
		}
		actions.append(action)
	print(actions)
	
func _player_setup():
	for i in rand_range(MIN_PLAYERS, MAX_PLAYERS):
		var player = VisualPlayer.instance()
		player.set_up(i + 5, Vector2(randi() % WIDTH, randi() % HEIGHT))
		players.append(player)
		$Players.add_child(player)
	

func _action():
	var action = actions.pop_front()
	
	print(action)
	if action:
		ball.move(action.position, timer.wait_time / 2)
		match(action["action"]):
			ACTIONS.PASS:
				print("pass")
				players[randi() % players.size()].move(action.position, timer.wait_time)
			ACTIONS.DRIBBLE:
				print("dribble")
				players[randi() % players.size()].move(action.position, timer.wait_time)
			ACTIONS.RUN:
				players[randi() % players.size()].move(action.position, timer.wait_time)
				print("run")
	else:
		print("shoot")
		ball.move($Field/Goal/Center.global_position, timer.wait_time / 2)


func _on_Timer_timeout():
	timer.wait_time = (randf() * 2) + 1
	timer.start()
	
	_action()
