extends Node

var pos = 0 # 0 is G, D is 1 etc

signal shoot
signal pass_to
signal pass_out # if he makes bad pas then ball goes out of field
signal dribble
signal wait
signal move_up
signal move_down

var sector_pos
var current_sector

var max_sector
var min_sector

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


var has_ball = false #probably detects when ball enters Ball detector

func _ready():
	add_to_group("simulator_player")

func kick_off():
	sector_pos = start_pos

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
		
		
	
func set_up(new_player,field_pos):
	pos = field_pos
	player = new_player
	if player["home"]:
		sector_pos = (field_pos+1) * 200
	else:
		sector_pos = 1200 -( (field_pos+1) * 200)
	current_sector = sector_pos/200
	start_pos = sector_pos
	
	min_sector = sector_pos - 300
	if min_sector < 0:
		min_sector = 0
	max_sector = sector_pos + 300
	if max_sector > 1200:
		max_sector = 1200
	
	
#	$Control/ShirtNumber.text = str(player["nr"])
#	$Control/ColorRect.color = color

func make_offensive_with_ball_decision():
	print(player["surname"] + " has ball")
	
	# make all checks and the make decision
	
	#modify multiplactors by team mentality
	var shoot_factor = check_shoot()
	var pass_factor = check_pass() * 60
	var move_up_factor = check_move_up() * 10
	var move_down_factor = check_move_down() * 10
	var wait_factor = 20
	
	var sum: int = shoot_factor + pass_factor + move_up_factor + move_down_factor + wait_factor
	var decision_factor = randi()%sum
	
	if decision_factor < shoot_factor:
		print("SHOOTS")
		emit_signal("shoot",player)
	elif decision_factor < (shoot_factor + pass_factor):
		print("PASS")
		emit_signal("pass_to",player)
	elif decision_factor < (shoot_factor + pass_factor + move_up_factor):
		print("MOVES UP")
		move_up()
		emit_signal("move_up",player)
	elif decision_factor < (shoot_factor + pass_factor + move_up_factor + move_down_factor):
		print("MOVES DOWN")
		move_down()
		emit_signal("move_down",player)
	else:
		print("WAITS")
		emit_signal("wait",player)


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
#	print(player["surname"] + " team has ball")
	
	var move_down_factor = check_move_down()
	var move_up_factor = check_move_up()
	var wait_factor = randi()%20 # make depending on player stats and tema mentality
	
	var sum = move_up_factor + move_down_factor + wait_factor
	var decision_factor = randi()%sum
	
	if decision_factor < move_up_factor:
#		print("MOVES UP")
		move_up()
		emit_signal("move_up",player)
	elif decision_factor < move_up_factor + move_down_factor:
#		print("MOVES DOWN")
		move_down()
		emit_signal("move_down",player)
	else:
#		print("WAITS")
		emit_signal("wait",player)
func make_defensive_decision():
	# check which sector has most opponent players and with ball and move there
#	print(player["surname"] + " defends")
	
	var move_down_factor = check_move_down()
	var move_up_factor = check_move_up()
	var wait_factor = randi()%20 # make depending on player stats and tema mentality
	
	var decision_factor = randi()%(move_up_factor + move_down_factor + wait_factor)
	
	if decision_factor < move_up_factor:
#		print("MOVES UP")
		emit_signal("move_up",player)
		move_down()
	elif decision_factor < move_up_factor + move_down_factor:
#		print("MOVES DOWN")
		emit_signal("move_down",player)
		move_up()
	else:
#		print("WAITS")
		emit_signal("wait",player)
	
func check_shoot():
	# check team mentality, if shooting from distance already shooting from far sectors
	var shoot_factor = current_sector + 8 # +8 to make max 20
	var opponent_players_in_sector = get_parent().get_team_players_in_sector(!player["home"],sector_pos)
	shoot_factor -= opponent_players_in_sector.size() * 4
	shoot_factor = max(shoot_factor,1)
	return shoot_factor
	
	
	
func check_pass():
	#add player vision affect
	#add pass mentality
	var pass_factor = 1
	var opponent_players_in_sector = get_parent().get_team_players_in_sector(!player["home"],sector_pos)
	var team_players_in_sector = get_parent().get_team_players_in_sector(player["home"],sector_pos)
	pass_factor -= opponent_players_in_sector.size() * 3
	pass_factor += opponent_players_in_sector.size() * 5
	pass_factor = max(pass_factor,1)
	return pass_factor
	
func check_move_up():
	# check opponentn players in next secor, if no players move up imedialtly
	var move_factor = 20
	var opponent_players_in_next_sector = []
	var team_players_in_next_sector = []
	if sector_pos < 1000:
		opponent_players_in_next_sector = get_parent().get_team_players_in_sector(!player["home"],sector_pos + 200)
		team_players_in_next_sector = get_parent().get_team_players_in_sector(player["home"],sector_pos + 200)
	move_factor -= opponent_players_in_next_sector.size() * 4
	move_factor += team_players_in_next_sector.size() * 5
	move_factor = min(move_factor,20)
	return move_factor
	
func check_move_down():
	var move_factor = 20
	var opponent_players_in_prev_sector = []
	var team_players_in_prev_sector = []
	if sector_pos > 200:
		opponent_players_in_prev_sector = get_parent().get_team_players_in_sector(!player["home"],sector_pos + 200)
		team_players_in_prev_sector = get_parent().get_team_players_in_sector(player["home"],sector_pos + 200)
	move_factor -= opponent_players_in_prev_sector.size() * 3
	move_factor += team_players_in_prev_sector.size() * 4
	move_factor = min(move_factor,20)
	return move_factor
	
func move_down():
	if player["home"]:
		sector_pos -= player["fisical"]["pace"] * 10
	else:
		sector_pos += player["fisical"]["pace"] * 10
	if sector_pos > max_sector:
		sector_pos = max_sector
	if sector_pos < min_sector:
		sector_pos = min_sector
	if player["home"]:
		current_sector = sector_pos / 200
	else:
		current_sector = (1200 - sector_pos) / 200
	

# special movements: cornerns, penlaties, free kicks, kick off, rimessa
func move_up():
	if player["home"]:
		sector_pos += player["fisical"]["pace"] * 10
	else:
		sector_pos -= player["fisical"]["pace"] * 10
	if sector_pos > max_sector:
		sector_pos = max_sector
	if sector_pos < min_sector:
		sector_pos = min_sector
	
	if player["home"]:
		current_sector = sector_pos / 200
	else:
		current_sector = (1200 - sector_pos) / 200
	

