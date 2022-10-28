extends Node2D

signal action_finished 

const VisualPlayer = preload("res://src/match-simulator/visual-action/actors/player/VisualPlayer.tscn")

onready var WIDTH = $Field.width
onready var HEIGHT = $Field.height

onready var timer = $Timer
onready var ball = $Ball

# list of random positions on the field, where the ball and at least one player moves
var actions = []
var attacking_players = []
var defending_players = []


var is_final_action = false

var is_home_goal

var is_goal

func _ready():
	randomize()

func _physics_process(delta):
	# look at ball
	$HomeGoalkeeper.sprite.look_at($Ball.global_position)
	$AwayGoalkeeper.sprite.look_at($Ball.global_position)
	for player in attacking_players:
		player.sprite.look_at($Ball.global_position)
	for player in defending_players:
		player.sprite.look_at($Ball.global_position)

	
func set_up(home_goal, _is_goal, home_team, away_team, action_buffer):
	is_home_goal = home_goal
	is_goal = _is_goal
	actions = action_buffer.duplicate(true)
	_player_setup(home_team, away_team)
	_actions_setup()
	


func _actions_setup():
	var x = WIDTH / 2
	var y = HEIGHT / 2
	
	for action in actions:
		# make positons move towards goal
		# with +/- tolerance, so that i can also move a bit backwards
		x += (randi() % (WIDTH / 6)) * ((randi() % 3) - 1)
			
		y = randi() % HEIGHT
		
		action["position"] = Vector2(x, y)
	
func _player_setup(_home_team, _away_team):
	var home_team = _home_team.duplicate(true)
	var away_team = _away_team.duplicate(true)
	
	#home
	var goalkeeper_home = home_team.players.active.pop_front()
	$HomeGoalkeeper.set_up(goalkeeper_home["nr"], Color.lightblue, true)
	for player in home_team.players.active:
		var visual_player = VisualPlayer.instance()
		visual_player.set_up(player["nr"], Color.blue, true, Vector2(randi() % WIDTH, randi() % HEIGHT))
		$HomePlayers.add_child(visual_player)
		if is_home_goal:
			attacking_players.append(visual_player)
		else:
			defending_players.append(visual_player)
	
	# away
	var goalkeeper_away = away_team.players.active.pop_front()
	$AwayGoalkeeper.set_up(goalkeeper_away["nr"], Color.lightcoral, true)
	for player in away_team.players.active:
		var visual_player = VisualPlayer.instance()
		visual_player.set_up(player["nr"], Color.red, false, Vector2(randi() % WIDTH, randi() % HEIGHT))
		$AwayPlayers.add_child(visual_player)
		if is_home_goal:
			defending_players.append(visual_player)
		else:
			attacking_players.append(visual_player)
	

func _action():
	var action = actions.pop_front()
		
	if action:
		ball.move(action.position, timer.wait_time / 2)
		var defender_position_distance = Vector2(rand_range(-50,50),rand_range(-50,50))
		match(action["action"]):
			ActionUtil.Attack.PASS, ActionUtil.Attack.CROSS:
				print("pass")
				_get_player_by_nr(attacking_players, action["attacking_player"]).move(action.position, timer.wait_time)
				_get_player_by_nr(defending_players, action["defending_player"]).move(action.position - defender_position_distance, timer.wait_time)
			ActionUtil.Attack.DRIBBLE:
				print("dribble")
				_get_player_by_nr(attacking_players, action["attacking_player"]).move(action.position, timer.wait_time)
				_get_player_by_nr(defending_players, action["defending_player"]).move(action.position - defender_position_distance, timer.wait_time)
			ActionUtil.Attack.RUN:
				_get_player_by_nr(attacking_players, action["attacking_player"]).move(action.position, timer.wait_time)
				_get_player_by_nr(defending_players, action["defending_player"]).move(action.position - defender_position_distance, timer.wait_time)
				print("run")
		get_tree().call_group("player", "random_movement", timer.wait_time)
	else:
		print("shoot")
		is_final_action = true
		
		var shot_deviation = Vector2(0,rand_range(-50,50))
		
		if not is_goal:
			shot_deviation = Vector2(0,rand_range(-250,250))
		
		if is_home_goal:
			ball.move($AwayGoal.global_position + shot_deviation, timer.wait_time / 3, true)
		else:
			ball.move($HomeGoal.global_position + shot_deviation, timer.wait_time / 3, true)
		

func _get_player_by_nr(players, nr):
	for player in players:
		if player["nr"] == nr:
			return player
	# in case the player has been changed or send of the pitch
	# TODO fix logical problem
	return players[randi() % players.size()]


func _on_Timer_timeout():
	timer.wait_time = rand_range(0.5,1.5)
	timer.start()
	
	if is_final_action:
		emit_signal("action_finished")
	else:
		_action()
