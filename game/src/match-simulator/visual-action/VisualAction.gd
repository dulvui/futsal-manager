extends Node2D

signal action_finished

const VisualPlayer = preload("res://src/match-simulator/visual-action/actors/player/VisualPlayer.tscn")

onready var WIDTH = $Field.width
onready var HEIGHT = $Field.height

onready var timer = $Timer
onready var ball = $Ball

var home_team
var away_team

var actions = []
var attacking_players = []
var defending_players = []

var is_final_action = false

var is_home_goal

var is_goal

# position - formation mapping
var formations = {
	"2-2" : ["DL","DR","AL","AR"]
}

onready var positions = {
	"DL" : {
		"attack" : Vector2(WIDTH * 3 / 8, HEIGHT * 3 / 4),
		"defense" : Vector2(WIDTH * 1 / 8, HEIGHT * 3 / 4)
	},
	"DR" : {
		"attack" : Vector2(WIDTH * 3 / 8, HEIGHT / 4),
		"defense" : Vector2(WIDTH * 1 / 8, HEIGHT / 4)
	},
	"AL" : {
		"attack" : Vector2(WIDTH * 7 / 8, HEIGHT * 3 / 4),
		"defense" : Vector2(WIDTH * 3 / 8, HEIGHT * 3 / 4)
	},
	"AR" : {
		"attack" : Vector2(WIDTH * 7 / 8, HEIGHT / 4),
		"defense" : Vector2(WIDTH * 3 / 8, HEIGHT / 4)
	}
}
# defines +/- the player differs from nomrla position
const POSITION_RANGE = 40

func _ready():
	randomize()
	
	_actions_setup()
	_player_setup()

func _physics_process(delta):
	# look at ball
	$HomeGoalkeeper.sprite.look_at($Ball.global_position)
	$AwayGoalkeeper.sprite.look_at($Ball.global_position)
	for player in attacking_players:
		player.sprite.look_at($Ball.global_position)
	for player in defending_players:
		player.sprite.look_at($Ball.global_position)

	
func set_up(home_goal, _is_goal, _home_team, _away_team, action_buffer):
	is_home_goal = home_goal
	is_goal = _is_goal
	actions = action_buffer.duplicate(true)
	home_team = _home_team.duplicate(true)
	away_team = _away_team.duplicate(true)


func _actions_setup():
	var x = WIDTH / 2
	var y = HEIGHT / 2
	
	for action in actions:
		x += (randi() % (WIDTH / 6)) * ((randi() % 3) - 1)
			
		y = randi() % HEIGHT
		
		# TODO
		# assign every player a postion according to the formation
		# ball position is set near active players position
		
		
		action["position"] = Vector2(x, y)

func _player_setup():
	#home
	var home_index = 0
	var goalkeeper_home = home_team.players.active.pop_front()
	$HomeGoalkeeper.set_up(goalkeeper_home["nr"], Color.lightblue, true)
	for player in home_team.players.active:
		var visual_player = VisualPlayer.instance()
		visual_player.set_up(player["nr"], Color.blue, true, _get_player_position(home_index, true))
		$HomePlayers.add_child(visual_player)
		if is_home_goal:
			attacking_players.append(visual_player)
		else:
			defending_players.append(visual_player)
		home_index += 1
	
	# away
	var away_index = 0
	var goalkeeper_away = away_team.players.active.pop_front()
	$AwayGoalkeeper.set_up(goalkeeper_away["nr"], Color.lightcoral, true)
	for player in away_team.players.active:
		var visual_player = VisualPlayer.instance()
		visual_player.set_up(player["nr"], Color.red, false, _get_player_position(away_index, false))
		$AwayPlayers.add_child(visual_player)
		if is_home_goal:
			defending_players.append(visual_player)
		else:
			attacking_players.append(visual_player)
		away_index += 1

# index: of player in active players representing the position in field
# action_type: attack or defense
func _get_player_position(index, is_home_team):
	# change valuse depending on formation
	# very index means differnet positon
	# for MVP only use 2-2 fomration
	
	var action_type = "defense"
	if (is_home_team and is_home_goal) or (not is_home_team and not is_home_goal):
		action_type = "attack"
	
	var field_position = formations["2-2"][index]
	var minimum = positions[field_position][action_type]
	var maximum = positions[field_position][action_type]
	
	# TODO adapt values depending on tactics
	var x = rand_range(minimum.x - POSITION_RANGE, minimum.x + POSITION_RANGE)
	var y = rand_range(minimum.y - POSITION_RANGE, minimum.y + POSITION_RANGE)
	
	# if away team move to other side
	if not is_home_team:
		x = WIDTH - x
		y = HEIGHT - y
	
	return Vector2(x,y)

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
