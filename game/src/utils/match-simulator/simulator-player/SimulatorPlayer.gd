extends Node

var pos = 0 # 0 is G, D is 1 etc

signal shoot
signal pass_to
signal pass_out # if he makes bad pas then ball goes out of field
signal dribble

var attack_pos
var defense_pos
var kick_off_pos
var current_pos

var goal_pos

var wait_counter = 0 # counts waits and after x  waits do action

var start_pos

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

func _ready():
	add_to_group("simulator_player")

func kick_off():
	current_pos = defense_pos

func set_up(new_player,new_kick_off_pos,new_pos):
	pos = new_pos
	player = new_player

	if player["home"]:
		kick_off_pos = new_kick_off_pos
		goal_pos = Vector2(1200,300)
		attack_pos = kick_off_pos + Vector2(400,0)
		defense_pos = kick_off_pos - Vector2(50,0)
	else:
		kick_off_pos = Vector2(1200,600) - new_kick_off_pos
		goal_pos = Vector2(0,300)
		attack_pos = kick_off_pos - Vector2(400,0)
		defense_pos = kick_off_pos + Vector2(50,0)
	current_pos = kick_off_pos
	
	
	
	

func update_decision(team_has_ball,has_ball):
	if pos > 0: # if not goalkeeper
		if team_has_ball:
			if has_ball:
				make_offensive_with_ball_decision()
			else:
				make_offensive_no_ball_decision()
		else:
			make_defensive_decision()
	else:
		if team_has_ball:
			if has_ball:
				make_goalkeeper_decision()
		
		
	

func make_offensive_with_ball_decision():
	print(player["surname"] + " has ball")
	
	# make all checks and the make decision
	
	#modify multiplactors by team mentality
	var shoot_factor = check_shoot()
	var pass_factor = check_pass() * 300
	var move_to_attackpos_factor = 80
	var wait_factor = 20
	
	var sum: int = shoot_factor + pass_factor + move_to_attackpos_factor + wait_factor
	var decision_factor = randi()%sum
	
	if decision_factor < shoot_factor:
		print("SHOOTS")
		player["has_ball"] = false
		emit_signal("shoot",player)
	elif decision_factor < (shoot_factor + pass_factor):
		print("PASS")
		player["has_ball"] = false
		emit_signal("pass_to",player)
	elif decision_factor < (shoot_factor + pass_factor + move_to_attackpos_factor):
		print("MOVES to attack pos")
		move_to_attack_pos()
	else:
		print("WAITS")


func make_goalkeeper_decision():
	print(player["surname"] + " as G has ball")
	
	# make all checks and the make decision
	
	#modify multiplactors by team mentality
	var pass_factor = check_pass() * 50
	var wait_factor = 20
	
	var sum: int = pass_factor +  wait_factor
	var decision_factor = randi()%sum
	
	if decision_factor <  pass_factor:
		print("PASS")
		emit_signal("pass_to",player)
	else:
		print("WAITS")
		emit_signal("wait",player)
	
func make_offensive_no_ball_decision():
	var distance = current_pos.distance_to(attack_pos)
	if distance > 20:
		move_to_attack_pos()
	else:
		move_to_bpp()
		

func make_defensive_decision():
	#check if player should try to attack player or stay in positon, when defense pos reached
	pass
	
func check_shoot():
	# check team mentality, if shooting from distance already shooting from far sectors
	var shoot_factor = 0
	
#	$Head.look_at(goal_pos)
	
	return shoot_factor
	
	
	
func check_pass():
	#-1 no pass, else pos to pas
	var pass_factor = -1
	var team_players = get_parent().home_team["players"]["active"]
	for player in team_players:
		if not player["has_ball"]:
			var pol = player["real"].current_pos
#			$Head.look_at(pol)
#			var collider = $Head.get_collider()
#			if collider != null:
#				print(collider["name"])
#	return pass_factor
	return 20
	
	
func move_to_defenese_pos():
	var distance = current_pos.distance_to(defense_pos)
	var direction = (defense_pos - current_pos).normalized()
	if distance > 20:
		current_pos += direction*player["fisical"]["pace"] * 5
	

# special movements: cornerns, penlaties, free kicks, kick off, rimessa
func move_to_attack_pos():
	
	var distance = current_pos.distance_to(attack_pos)
	var direction = (attack_pos - current_pos).normalized()
	if distance > 20:
		current_pos += direction*player["fisical"]["pace"] * 5
	
func move_to_bpp():
	#like in book to bring in player movemnts, but just in player near area
	pass 

