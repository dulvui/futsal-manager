extends Node2D

const VisualPlayer = preload("res://src/match-simulator/visual-action/actors/player/VisualPlayer.tscn")

const MAX_POSITIONS = 10
const MIN_POSITIONS = 2
const POSITION_RANGE = MAX_POSITIONS - MIN_POSITIONS

const MAX_PLAYERS = 5
const MIN_PLAYERS = 2
const PLAYER_RANGE = MAX_PLAYERS - MIN_PLAYERS

const WIDTH = 200
const HEIGHT = 200

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
	for i in (randf() * POSITION_RANGE) + MIN_POSITIONS:
		var action = {
			"position": Vector2(randi() % WIDTH, randi() % HEIGHT),
			"action": ACTIONS.values()[randi() % ACTIONS.size()]
		}
		actions.append(action)
	print(actions)
	
func _player_setup():
	for i in (randf() * PLAYER_RANGE) + MIN_PLAYERS:
		var player = VisualPlayer.instance()
		player.set_up({"nr" : 1})
		players.append(player)
	

func _action():
	var action = actions.pop_front()
	
	if action:
		ball.move(action.position, timer.wait_time)
		# attacker.
	else:
		# shoot
		pass

func _on_Timer_timeout():
	timer.wait_time = (randf() * 5) + 1
	timer.start()
	
	_action()
