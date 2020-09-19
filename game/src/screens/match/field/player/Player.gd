extends KinematicBody2D

export (String, "G", "D", "WL", "WR", "P") var pos = "G"

var current_destination
enum player_states {MOVING,WAITING,SHOOTING,KICK_OFF,GK,
						KICK_IN,CORNER,PENALTY,FREE_KICK}
var current_state

var visible_field_spots = []

var visible_team_players = []
var visible_opponent_players = []

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



var player
var surname = ""

onready var ball = get_parent().get_node("Ball")

export var shirt_number = "1"
export var shirt_color = Color.red

var ball_pos

var has_ball = false #probably detects when ball enters Ball detector

var looking = false

func _ready():
	ball_pos = $BallPosition.global_position
	
func _physics_process(delta):
	if ball !=  null and not looking:
		look_at(ball.global_position)
	_move()


func update_decision(team_has_ball,has_ball):
	match current_state:
		player_states.KICK_OFF:
			pass
		player_states.KICK_IN:
			pass
		player_states.MOVING:
			pass
		player_states.CORNER:
			pass
	
	
	
	if team_has_ball:
		if has_ball:
			make_offensive_with_ball_decision()
		else:
			make_offensive_no_ball_decision()
	else:
		make_defensive_decision()
		
#	move_to_spot()
		
	
func set_up(new_player, pos, color):
	player = new_player
	$Control/ShirtNumber.text = str(player["nr"])
	$Control/ColorRect.color = color
	current_destination = pos

# look around: check if goal can be scored,
# check if player is in good pass position
# else move, dribble or wait depending on mentality of team
# move towards best free position nearest to goal until next iteration

#look around: get position of other players and value:nearest_d_distance + goal_distance
# value gets tollerance by vision stats of player, so if 20 no tollerance, 0 full tollerance

# pass ball: pass to positon of player, if no defender intercepts, pass goes trough

# intercept passes: move towards player or ball depending on team mentality
# player has area that detects ball, if intercepts player gets possesion,
# else ball can go trough player, like a tunnel ;)

#player receives pass, if ball comes into player area, he stops the ball,
# depending on player stats of first touch

#move: player accelaerates and gets max velocity depending on stats
# moves from one position to next from iteration to interation
# calculate best position to move depending on mentality stats of player
func make_offensive_with_ball_decision():
	print(player["surname"])
	
	if check_shoot():
		print("SHOOTS")
		shoot()
	elif check_pass():
		print("PASSES")
		pass_to_player(player)
	elif check_move():
		print("MOVES")
		move_to_spot()
	else:
		print("WAITS")
		wait()
		
	
func make_offensive_no_ball_decision():
	print(player["surname"])
	
	if check_bpp():
		print("MOVES TO BPP")
		move_to_spot()
	else:
		print("WAITS")
		wait()

func make_defensive_decision():
	mark_nearest_player()
	
func check_shoot():
	#check current field spot if goal is possible
	# if near to goal, player may also shoot if intercepted by goalkeeper or d
	pass
	
func check_pass():
	# ierate over other players
	#check with player raycast if pass possible to player
	# get value of players fieldspot if the can score a goal
	# or even if they could make a good pass or move (make prediction of actions)
	# if one value is good enough, pick highest and pass
	
	# check players in vision area and look with raycast at it, if no toher collider
	# pass can be done
	looking = true
	for player in visible_team_players:
		look_at(player.global_position)
		var collider = $Head.get_collider()
		if collider == player:
			print("PAS POSSIBLE")
	looking = false
	return true
	
func check_move():
	# check nearest field spots or in fieldspot detector
	# choose that with best value
	# player is in state MOVING until reaches the spot, or defender intecepts
	return true
	
func check_bpp():
	return true

func shoot():
	var direction
	ball.apply_central_impulse(direction)
	
func pass_to_player(new_player):
#	ball.move_to(new_player.global_position)
	pass
	
func wait():
	pass
#func move():
#	pass
	
func _move():
	var direction = (current_destination - global_position).normalized()
	#accelerate before
	move_and_slide(direction * player["fisical"]["pace"] * 50)
	ball_pos = $BallPosition.global_position

# special movements: cornerns, penlaties, free kicks, kick off, rimessa
func move(destination):
	current_destination = destination
	
func move_to_spot():
	if visible_field_spots.size() > 0:
		var field_spot_value = visible_field_spots[0].get_home_goal_value()
		var field_spot
		for i in range(visible_field_spots.size()):
			if field_spot_value < visible_field_spots[i].get_home_goal_value():
				field_spot_value = visible_field_spots[i].get_home_goal_value()
				field_spot = visible_field_spots[i]
		if field_spot != null:
			current_destination = field_spot.global_position

	
	

func pass_ball():
	#make calculations if pass is succesful,
	# the sned succes signal, else fail
	pass
	#TWEEN
	
# move to player or ball, whatever closer is.
func mark_nearest_player():
	var distance = 9999999999
	var player_to_mark
	for visible_player in visible_opponent_players:
		if global_position.distance_to(visible_player.global_position) < distance:
			distance = global_position.distance_to(visible_player.global_position)
			player_to_mark = visible_player
	if player_to_mark != null:
		current_destination = player_to_mark.global_position + Vector2(-80,0) # to mark a bit behind player
# to get visible fiel spots
func _on_FieldSpotDetector_area_entered(area):
	visible_field_spots.append(area.get_parent())

# checks if ball or player enters vision field
# also players tha ball can be passed to??
func _on_Vision_body_entered(body):
	if body.is_in_group("player"):
		if body.player["field"] == player["field"]:
			visible_team_players.append(body)
		else:
			visible_opponent_players.append(body)


func _on_FieldSpotDetector_area_exited(area):
	visible_field_spots.erase(area.get_parent())


func _on_Vision_body_exited(body):
	visible_opponent_players.erase(body)
	visible_team_players.erase(body)
