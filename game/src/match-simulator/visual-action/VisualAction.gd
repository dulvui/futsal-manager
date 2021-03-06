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
var attacking_players = []
var defending_players = []


var is_final_action = false

var is_home_goal

func _ready():
	randomize()

func _physics_process(delta):
	# look at ball
	$HomeGoalkeeper.look_at($Ball.global_position)
	$AwayGoalkeeper.look_at($Ball.global_position)
	for player in attacking_players:
		player.look_at($Ball.global_position)
	for player in defending_players:
		player.look_at($Ball.global_position)

	
func set_up(home_goal):
	is_home_goal = home_goal
	_player_setup()
	_actions_setup()
	
func _actions_setup():
	var x = WIDTH / 2
	var y = HEIGHT / 2
	
	for i in rand_range(MIN_POSITIONS, MAX_POSITIONS):
		
		# make positons move towards goal
		# with +/- tolerance, so that i can also move a bit backwards
		if is_home_goal:
			x -= randi() % (WIDTH / MAX_POSITIONS / 2)
		else:
			x += randi() % (WIDTH / MAX_POSITIONS / 2)
			
		y = randi() % HEIGHT
		
		var action = {
			"position": Vector2(x, y),
			"action": ACTIONS.values()[randi() % ACTIONS.size()]
		}
		actions.append(action)
	
func _player_setup():
	#home
	var rand_number = (randi() % 10) + 2
	for i in rand_range(MIN_PLAYERS, MAX_PLAYERS):
		var player = VisualPlayer.instance()
		player.set_up(i + rand_number, Vector2(randi() % WIDTH, randi() % HEIGHT), Color.blue, true)
		$HomePlayers.add_child(player)
		if is_home_goal:
			attacking_players.append(player)
		else:
			defending_players.append(player)
	
	# away
	rand_number = (randi() % 10) + 2
	for i in rand_range(MIN_PLAYERS, MAX_PLAYERS):
		var player = VisualPlayer.instance()
		player.set_up(i + rand_number, Vector2(randi() % WIDTH, randi() % HEIGHT), Color.red, false)
		$AwayPlayers.add_child(player)
		if is_home_goal:
			defending_players.append(player)
		else:
			attacking_players.append(player)
	

func _action():
	var action = actions.pop_front()
	
	print(action)
	if action:
		ball.move(action.position, timer.wait_time / 2)
		var defender_position_distance = Vector2(rand_range(-50,50),rand_range(-50,50))
		match(action["action"]):
			ACTIONS.PASS:
				print("pass")
				attacking_players[randi() % attacking_players.size()].move(action.position, timer.wait_time)
				defending_players[randi() % defending_players.size()].move(action.position - defender_position_distance, timer.wait_time)
			ACTIONS.DRIBBLE:
				print("dribble")
				attacking_players[randi() % attacking_players.size()].move(action.position, timer.wait_time)
				defending_players[randi() % defending_players.size()].move(action.position - defender_position_distance, timer.wait_time)
			ACTIONS.RUN:
				attacking_players[randi() % attacking_players.size()].move(action.position, timer.wait_time)
				defending_players[randi() % defending_players.size()].move(action.position - defender_position_distance, timer.wait_time)
				print("run")
		get_tree().call_group("player", "random_movement", timer.wait_time)
	else:
		print("shoot")
		is_final_action = true
		if is_home_goal:
			ball.move($HomeGoal.global_position, timer.wait_time / 3, true)
		else:
			ball.move($AwayGoal.global_position, timer.wait_time / 3, true)
		


func _on_Timer_timeout():
	timer.wait_time = rand_range(0.5,1.5)
	timer.start()
	
	if is_final_action:
		emit_signal("action_finished")
	else:
		_action()
