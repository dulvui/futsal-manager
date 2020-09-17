extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

const Player = preload("res://src/screens/match/field/player/Player.tscn")

var home_team = {}
var away_team = {}

var home_stats = {
	"goals" : 0,
	"possession" : 50,
	"shots" : 0,
	"shots_on_target" : 0,
	"pass" : 0,
	"pass_success" : 0,
	"free_kicks" : 0,
	"penalty" : 0,
	"penalty_kick" : 0, # after 6 fouls
	"fouls" : 0,
	"tackles" : 0,
	"tackles_success" : 0,
	"corners" : 0,
	"headers" : 0,
	"headers_success" : 0,
	"throw_in" : 0, #rimessa
	"yellow_cards" : 0,
	"red_cards" : 0
}
var away_stats = {
	"goals" : 0,
	"possession" : 50,
	"shots" : 0,
	"shots_on_target" : 0,
	"pass" : 0,
	"pass_success" : 0,
	"free_kicks" : 0,
	"penalty" : 0,
	"penalty_kick" : 0, # after 6 fouls
	"fouls" : 0,
	"tackles" : 0,
	"tackles_success" : 0,
	"corners" : 0,
	"headers" : 0,
	"headers_success" : 0,
	"throw_in" : 0, #rimessa
	"yellow_cards" : 0,
	"red_cards" : 0
}

const DECISIONS = ["PASS","DRIBBLE","SHOOT","MOVE","WAIT"]

var time = 0.0

var home_possess_counter = 0.0

var formation_pos_mapping = {
	"2-2" : [3,7,9,19,17],
	"1-2-1" : [3,8,12,14,18],
	"1-1-2" : [3,8,13,19,17],
	"2-1-1" : [3,7,9,13,18],
	"4-0" : [3,7,9,15,18],
	"3-1" : [3,8,7,9,18],
	"1-3" : [3,8,17,19,18],
}

var home_has_ball

func set_up(home,away, match_started):
	home_team = home.duplicate(true)
	away_team = away.duplicate(true)
	
	
	for i in range(home_team["players"]["active"].size()):
		var player = home_team["players"]["active"][i]
		player["has_ball"]  = false
		var real_player = Player.instance()
		real_player.set_up(player,get_node("HomeFieldSpots/FieldSpot" + str(formation_pos_mapping[home_team["formation"]][i])).global_position,Color.red)
		add_child(real_player)
		player["real"] = real_player

	for i in range(away_team["players"]["active"].size()):
		var player = away_team["players"]["active"][i]
		player["has_ball"]  = false
		var real_player = Player.instance()
		real_player.set_up(player,get_node("AwayFieldSpots/FieldSpot" + str(formation_pos_mapping[away_team["formation"]][i])).global_position,Color.blue)
		add_child(real_player)
		player["real"] = real_player



	if match_started:
		home_has_ball = randi()%2 == 0
		if home_has_ball:
			home_team["players"]["active"][4]["has_ball"] = true
		else:
			away_team["players"]["active"][4]["has_ball"] = true

func change_players(new_home_team,new_away_team):
	home_team = new_home_team.duplicate(true)
	away_team = new_away_team.duplicate(true)
	
	for i in range(home_team["players"]["active"].size()):
		var player = home_team["players"]["active"][i]
		player["has_ball"]  = false
		var real_player = Player.instance()
		real_player.set_up(player,get_node("HomeFieldSpots/FieldSpot" + str(formation_pos_mapping[home_team["formation"]][i])).global_position,Color.red)
		add_child(real_player)
		player["real"] = real_player

	for i in range(away_team["players"]["active"].size()):
		var player = away_team["players"]["active"][i]
		player["has_ball"]  = false
		var real_player = Player.instance()
		real_player.set_up(player,get_node("AwayFieldSpots/FieldSpot" + str(formation_pos_mapping[away_team["formation"]][i])).global_position,Color.blue)
		add_child(real_player)
		player["real"] = real_player
	
	
	#make better and look who has ball after interruption
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["active"][4]["has_ball"] = true
	else:
		away_team["players"]["active"][4]["has_ball"] = true
		
	
			
			
func update_time():
	time += 1
	if home_has_ball:
		home_possess_counter += 1
		
#	$Field.random_pass()

	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]

func update():
	if home_has_ball:
		_make_home_decisions()
	else:
		_make_away_decisions()
		
	
	
func _make_home_decisions():
	_make_offensive_decision(home_team["players"]["active"][0],0)
	_make_offensive_decision(home_team["players"]["active"][1],1)
	_make_offensive_decision(home_team["players"]["active"][2],2)
	_make_offensive_decision(home_team["players"]["active"][3],3)
	_make_offensive_decision(home_team["players"]["active"][4],4)

		
func _make_away_decisions():
	_make_offensive_decision(away_team["players"]["active"][0],0)
	_make_offensive_decision(away_team["players"]["active"][1],1)
	_make_offensive_decision(away_team["players"]["active"][2],2)
	_make_offensive_decision(away_team["players"]["active"][3],3)
	_make_offensive_decision(away_team["players"]["active"][4],4)


func _make_offensive_decision(player,pos):
	if player["has_ball"]:
		print(player["surname"] + " has ball")
		var decision = _what_offensive_decision(player,pos) # make it affected by tactic, formation and in which sector player is
		match decision:
			"PASS":
				print(" and passes the ball")
				_pass_to(player,randi()%5)
			"SHOOT":
				print(" and shoots the ball")
				_shoot(player,pos)
			"DRIBBLE":
				print(" and dribbles")
				_dribble(player,pos)
			"MOVE":
				print(" and moves")
				_move_with_ball(player)
			"WAIT":
				print(" and waits")
				_wait(player)
#
	else:
		print(player["surname"])
		var decision = _what_offensive_decision_no_ball(player,pos) # make it affected by tactic, formation and in which sector player is
		match decision:
			"MOVE":
				print(" moves")
				_move_with_ball(player)
			"WAIT":
				print(" waits")
				_wait(player)

func _what_offensive_decision(player,pos):
	var decision
	var factor = randi()%100
	
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
	
	
	
	match pos:
		0:
			decision = "PASS"
		1:
			decision = "PASS"
		2:
			if factor < 60:
				decision = "PASS"
			elif factor < 95:
				decision = "DRIBBLE"
			else:
				decision = "SHOOT"
		3:
			if factor < 60:
				decision = "PASS"
			elif factor < 95:
				decision = "DRIBBLE"
			else:
				decision = "SHOOT"
		4:
			if factor < 50:
				decision = "PASS"
			elif factor < 98:
				decision = "DRIBBLE"
			else:
				decision = "SHOOT"
	return decision
	


func _what_offensive_decision_no_ball(player,pos):
	pass
	
func _make_defensive_decision(player,pos):
	
	# depending on team mentality the player marks in zone or the player
	# with stats of player, so attacker that has good def stats also marks good
	# so the better the stats the better postion the player gets itself
	# to intercept the ball
	
	# player marks nearest player, depending on vision stats
	# so players with bad vision and defensive movement,
	# could mark the same player until one sees the error(how ?)
	
	_move(player)

func _move(player):
	# players move freely around, if corner etc move to team tactic position
	# player calls "prima" o "seconda" with visual emoji too if used
	pass
	
func _move_with_ball(player):
	pass
	
func _shoot(player,position):
	
	if home_has_ball:
		home_stats["shots"] += 1
	else:
		away_stats["shots"] += 1
	
	# look also for long shoot in next iteration
	player["has_ball"] = false
	var shoot_factor:int = player["technical"]["shoot"]
	
		
	var nearest_defender = _get_nearest_defender(position)
	var intercept_factor:int = nearest_defender["technical"]["interception"]
	
	var result = randi()% (shoot_factor + (intercept_factor * 3)) #too many golas, increase intercept
	
	print("shoot %s vs intercept %s  = %s"%[str(shoot_factor),str(intercept_factor),str(result)])
	
	if result <= shoot_factor:
		#check goalie stats, but goal for now
		print("GOALLLLLL")
		if home_has_ball:
			emit_signal("home_goal")
			home_stats["goals"] += 1
			home_has_ball = false
			away_team["players"]["active"][4]["has_ball"] = true
			$Ball.move_to($AwayGoal/ShootSpotCenter.global_position)
		else:
			emit_signal("away_goal")
			away_stats["goals"] += 1
			home_has_ball = true
			home_team["players"]["active"][4]["has_ball"] = true
			$Ball.move_to($HomeGoal/ShootSpotCenter.global_position)
	else:
		print("Interception")
		if home_has_ball:
			home_has_ball = false
			away_team["players"]["active"][1]["has_ball"] = true
		else:
			home_has_ball = true
			home_team["players"]["active"][1]["has_ball"] = true
	
func _dribble(player,position):
	var dribble_factor:int = player["technical"]["dribble"]
	var nearest_defender = _get_nearest_defender(position)
	var defense_factor:int = nearest_defender["technical"]["interception"]
	
	var result = randi()%(dribble_factor + defense_factor)
	
	if result <= dribble_factor:
		print("dribble success")
	else:
		print("dribble failure")
		home_has_ball = !home_has_ball
		_give_nearest_defender_ball(position)
		player["has_ball"] = false
	
func _wait(player):
	pass
	
func _pass_to(player,position):
	print(player["name"] + " passes to " + str(position))
	player["has_ball"] = false
	
	if home_has_ball:
		home_stats["pass"] += 1
	else:
		away_stats["pass"] += 1
	

	var nearest_defender = _get_nearest_defender(position)
	var pass_stats:int = 1
	
	var is_short = randi()%20 < 10 #team_posses["offensive_tactics"]["O1"]
	
	if is_short:
		print("short pass")
		pass_stats = player["technical"]["pass"]
	else:
		print("long pass")
		pass_stats = player["technical"]["long_pass"]
	
	var defender_stats:int = nearest_defender["technical"]["marking"]
#	var will_do_pressing = randi()%20 > team_no_posses["defensive_tactics"]["D1"]
#
#	if will_do_pressing:
#		#reduce stamina
#		pass
#
	var result = randi()% (pass_stats + defender_stats)
	
	print("pass %s vs mark %s = %s"%[str(pass_stats),str(defender_stats),str(result)])
	
	
	if result <= pass_stats:
		print("SUCCESS")
#		emit_signal("home_pass",[position])
		if home_has_ball:
			home_team["players"]["active"][position]["has_ball"] = true
			home_stats["pass_success"] += 1
			$Ball.move_to(home_team["players"]["active"][position]["real"].ball_pos)
		else:
			away_team["players"]["active"][position]["has_ball"] = true
			away_stats["pass_success"] += 1
			$Ball.move_to(away_team["players"]["active"][position]["real"].ball_pos)
	else:
		print("INTERCEPT")
		player["has_ball"] = false
#		emit_signal("away_pass",[position])
		home_has_ball = !home_has_ball
		_give_nearest_defender_ball(position)
	
		
	
func _get_nearest_defender(position):
	var team
	if home_has_ball:
		return home_team["players"]["active"][position]
	else:
		return away_team["players"]["active"][position]
			
func _give_nearest_defender_ball(position):
	var team
	if home_has_ball:
		match position:
			0:
				home_team["players"]["active"][4]["has_ball"] = true
			1:
				home_team["players"]["active"][4]["has_ball"] = true
			2:
				home_team["players"]["active"][2]["has_ball"] = true
			3:
				home_team["players"]["active"][3]["has_ball"] = true
			4:
				home_team["players"]["active"][1]["has_ball"] = true
	else:
		match position:
			0:
				away_team["players"]["active"][4]["has_ball"] = true
			1:
				away_team["players"]["active"][4]["has_ball"] = true
			2:
				away_team["players"]["active"][2]["has_ball"] = true
			3:
				away_team["players"]["active"][3]["has_ball"] = true
			4:
				away_team["players"]["active"][1]["has_ball"] = true
	


func _on_GameField_body_exited(body):
	# check if ball exited in corner or on side, then prepare corner or kickin
	pass # Replace with function body.



