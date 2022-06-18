extends Node2D

signal action_finished 

const VisualPlayer = preload("res://src/match-simulator/visual-action/actors/player/VisualPlayer.tscn")

const MAX_POSITIONS = 10
const MIN_POSITIONS = 2

const MAX_PLAYERS = 5
const MIN_PLAYERS = 2

onready var WIDTH = $Field.width
onready var HEIGHT = $Field.height

onready var attacker = $Attacker
onready var attacker2 = $Attacker2
onready var timer = $Timer
onready var ball = $Ball

# shoot is final action, happens always
enum ACTIONS {PASS, RUN, DRIBBLE} 

# list of random positions on the field, where the ball and at least one player moves
var actions = []
var players = []

var is_final_action = false

var is_home_goal


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
func set_up(home_goal):
	_player_setup()
	_actions_setup()
	is_home_goal = home_goal
	
func _actions_setup():
	for i in rand_range(MIN_POSITIONS, MAX_POSITIONS):
		
		# make positons move towards goal
		# with +/- tolerance, so that i can also move a bit backwards
		var action = {
			"position": Vector2(randi() % WIDTH, randi() % HEIGHT),
			"action": ACTIONS.values()[randi() % ACTIONS.size()]
		}
		actions.append(action)
	
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
		is_final_action = true
		if is_home_goal:
			ball.move($Field.home_goal_center, timer.wait_time / 3)
		else:
			ball.move($Field.away_goal_center, timer.wait_time / 3)
		


func _on_Timer_timeout():
	timer.wait_time = (randf() * 2) + 1
	timer.start()
	
	if is_final_action:
		emit_signal("action_finished")
		queue_free()
	else:
		_action()
