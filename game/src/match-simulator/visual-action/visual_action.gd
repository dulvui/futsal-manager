# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

signal action_finished

const VisualPlayer:PackedScene = preload("res://src/match-simulator/visual-action/actors/player/visual_player.tscn")

const RUN_DISTANCE:int = 300

@onready var WIDTH:int = $Field.width
@onready var HEIGHT:int = $Field.height

@onready var timer:Timer = $Timer
@onready var ball:Node2D = $Ball

var home_team
var away_team

var actions = []
var home_visual_players = []
var away_visual_players = []

var is_final_action:bool = false

var is_home_goal:bool

var is_goal:bool

var is_shooting:bool = false

# position - formation mapping
var formations = {
	"2-2" : ["DL","DR","AL","AR"]
}

@onready var positions = {
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

func _ready() -> void:
	randomize()
	_player_setup()

func _physics_process(delta) -> void:
	# look at ball
	if not is_shooting:
		$HomeGoalkeeper.sprite.look_at($Ball.global_position)
		$AwayGoalkeeper.sprite.look_at($Ball.global_position)
	for player in home_visual_players:
		player.sprite.look_at($Ball.global_position)
	for player in away_visual_players:
		player.sprite.look_at($Ball.global_position)
		
	# referee
	$Referee/Sprites.look_at($Ball.global_position)
	$Referee2/Sprites.look_at($Ball.global_position)

		
func set_up(home_goal, _is_goal, _home_team, _away_team, action_buffer) -> void:
	is_home_goal = home_goal
	is_goal = _is_goal
	actions = action_buffer.duplicate(true)
	home_team = _home_team.duplicate(true)
	away_team = _away_team.duplicate(true)
	
	# reduce actons randomly
	actions = actions.slice(randi() % actions.size() - 3, actions.size())
	
	
func _player_setup() -> void:
	#home
	var home_index = 0
	var goalkeeper_home = home_team.players.active.pop_front()
	$HomeGoalkeeper.set_up(goalkeeper_home["nr"], Color.LIGHT_BLUE, true, WIDTH, HEIGHT)
	for player in home_team.players.active:
		var visual_player = VisualPlayer.instantiate()
		visual_player.set_up(player["nr"], Color.BLUE, true, WIDTH, HEIGHT, _get_player_position(home_index, true))
		$HomePlayers.add_child(visual_player)
		home_visual_players.append(visual_player)
		home_index += 1
	
	# away
	var away_index = 0
	var goalkeeper_away = away_team.players.active.pop_front()
	$AwayGoalkeeper.set_up(goalkeeper_away["nr"], Color.LIGHT_CORAL, true, WIDTH, HEIGHT)
	for player in away_team.players.active:
		var visual_player = VisualPlayer.instantiate()
		visual_player.set_up(player["nr"], Color.RED, false, WIDTH, HEIGHT, _get_player_position(away_index, false))
		$AwayPlayers.add_child(visual_player)
		away_visual_players.append(visual_player)
		away_index += 1

# index: of player in active players representing the position in field
# action_type: attack or defense
func _get_player_position(index, is_home_team) -> Vector2:
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
	var x = randi_range(minimum.x - POSITION_RANGE, minimum.x + POSITION_RANGE)
	var y = randi_range(minimum.y - POSITION_RANGE, minimum.y + POSITION_RANGE)
	
	# if away team move to other side
	if not is_home_team:
		x = WIDTH - x
		y = HEIGHT - y
	
	return Vector2(x,y)

func _action() -> void:
	var action = actions.pop_front()
	
	print(action)
	
	# TODO
	# iterate over players and move active players
	# according to action
	# other players make random move
	
	# TODO
	# corner
	# foul
	# free kick
	# penalty
		
	if action:
		var attack_nr = action["attacking_player_nr"]
		var defense_nr = action["defending_player_nr"]
		
		# find current player position
		if action["is_home"]:
			for player in home_visual_players:
				if player.nr == attack_nr:
					if action["action"] == "RUN":
						var desitionation = player.position +  Vector2(randi_range(-RUN_DISTANCE,RUN_DISTANCE),randi_range(-RUN_DISTANCE,RUN_DISTANCE))
						desitionation = player.move(desitionation, timer.wait_time)
						action["position"] = desitionation
					else:
						action["position"] = player.position
					break
		else:
			for player in away_visual_players:
				if player.nr == attack_nr:
					if action["action"] == "RUN":
						var desitionation = player.position +  Vector2(randi_range(-RUN_DISTANCE,RUN_DISTANCE),randi_range(-RUN_DISTANCE,RUN_DISTANCE))
						desitionation = player.move(desitionation, timer.wait_time)
						action["position"] = desitionation
					else:
						action["position"] = player.position
					break
			
		
		ball.move(action.position, timer.wait_time)
		
		# referee
		if action.position.x < WIDTH / 2:
			$Referee.follow_ball(action.position, timer.wait_time )
		else:
			$Referee2.follow_ball(action.position, timer.wait_time)
		
		get_tree().call_group("player", "random_movement", timer.wait_time)
	else:
		print("shoot")
		is_final_action = true
		is_shooting = true
		
		var shot_deviation = Vector2(0,randi_range(-50,50))
		
		if not is_goal:
			shot_deviation = Vector2(0,randi_range(-250,250))
			
			# stop ball on goalkeeper position
			if is_home_goal:
				shot_deviation.x -= 90
			else:
				shot_deviation.x += 90
		

		if is_home_goal:
			ball.move($AwayGoal.global_position + shot_deviation, timer.wait_time / 3, true)
			# goalkeeper save
			if shot_deviation.y < 100 and shot_deviation.y > -100:
				$AwayGoalkeeper.move($AwayGoal.position + shot_deviation, timer.wait_time / 3)
		else:
			ball.move($HomeGoal.global_position + shot_deviation, timer.wait_time / 3, true)
			# goalkeeper save
			if shot_deviation.y < 100 and shot_deviation.y > -100:
				$HomeGoalkeeper.move($HomeGoal.position + shot_deviation, timer.wait_time / 3)
		

func _get_player_by_nr(players, nr) -> Dictionary:
	for player in players:
		if player["nr"] == nr:
			return player
	# in case the player has been changed or send of the pitch
	# TODO fix logical problem
	return players[randi() % players.size()]


func _on_Timer_timeout() -> void:
	timer.wait_time = randf_range(0.5,1.5)
	timer.start()
	
	if is_final_action:
		emit_signal("action_finished")
	else:
		_action()