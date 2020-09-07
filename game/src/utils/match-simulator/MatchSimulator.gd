extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

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
const POS = ["G","D","WL","WR","P"]

var time = 0.0

var home_possess_counter = 0.0


var home_has_ball

func set_up(home,away):
	home["players"]["G"]["has_ball"]  = false
	home["players"]["D"]["has_ball"]  = false
	home["players"]["WL"]["has_ball"]  = false
	home["players"]["WR"]["has_ball"]  = false
	home["players"]["P"]["has_ball"]  = false

	away["players"]["G"]["has_ball"]  = false
	away["players"]["D"]["has_ball"]  = false
	away["players"]["WL"]["has_ball"]  = false
	away["players"]["WR"]["has_ball"]  = false
	away["players"]["P"]["has_ball"]  = false

	home_team = home.duplicate(true)
	away_team = away.duplicate(true)

	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["P"]["has_ball"] = true
	else:
		away_team["players"]["P"]["has_ball"] = true

func change_players(new_home_team,new_away_team):
	home_team = new_home_team.duplicate(true)
	away_team = new_away_team.duplicate(true)
	
	home_team["players"]["G"]["has_ball"]  = false
	home_team["players"]["D"]["has_ball"]  = false
	home_team["players"]["WL"]["has_ball"]  = false
	home_team["players"]["WR"]["has_ball"]  = false
	home_team["players"]["P"]["has_ball"]  = false

	away_team["players"]["G"]["has_ball"]  = false
	away_team["players"]["D"]["has_ball"]  = false
	away_team["players"]["WL"]["has_ball"]  = false
	away_team["players"]["WR"]["has_ball"]  = false
	away_team["players"]["P"]["has_ball"]  = false
	
	
	#make better and look who has ball after interuption
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["P"]["has_ball"] = true
	else:
		away_team["players"]["P"]["has_ball"] = true
			
			
func update_time():
	time += 1
	if home_has_ball:
		home_possess_counter += 1

	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]

func update():
	if home_has_ball:
		_make_home_decisions()
	else:
		_make_away_decisions()
		
	
	
func _make_home_decisions():
	_make_offensive_decision(home_team["players"]["G"],"G")
	_make_offensive_decision(home_team["players"]["D"],"D")
	_make_offensive_decision(home_team["players"]["WL"],"WL")
	_make_offensive_decision(home_team["players"]["WR"],"WR")
	_make_offensive_decision(home_team["players"]["P"],"P")

		
func _make_away_decisions():
	_make_offensive_decision(away_team["players"]["G"],"G")
	_make_offensive_decision(away_team["players"]["D"],"D")
	_make_offensive_decision(away_team["players"]["WL"],"WL")
	_make_offensive_decision(away_team["players"]["WR"],"WR")
	_make_offensive_decision(away_team["players"]["P"],"P")


func _make_offensive_decision(player,pos):
	if player["has_ball"]:
		print(player["surname"] + " has ball")
		var decision = _what_offensive_decision(player,pos) # make it affected by tactic, formation and in which sector player is
		match decision:
			"PASS":
				print(" and passes the ball")
				_pass_to(player,POS[randi()%POS.size()])
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
#	else:
#		_make_defensive_decision(player,pos) # or wait, depending on workrate, teamwork, defensive/offensive movement

func _what_offensive_decision(player,pos):
	var decision
	var factor = randi()%100
	
	match pos:
		"G":
			decision = "PASS"
		"D":
			decision = "PASS"
		"WL":
			if factor < 60:
				decision = "PASS"
			elif factor < 95:
				decision = "DRIBBLE"
			else:
				decision = "SHOOT"
		"WR":
			if factor < 60:
				decision = "PASS"
			elif factor < 95:
				decision = "DRIBBLE"
			else:
				decision = "SHOOT"
		"P":
			if factor < 50:
				decision = "PASS"
			elif factor < 98:
				decision = "DRIBBLE"
			else:
				decision = "SHOOT"
	return decision
	
		
func _make_defensive_decision(player,pos):
	_move(player)

func _move(player):
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
			away_team["players"]["P"]["has_ball"] = true
		else:
			emit_signal("away_goal")
			away_stats["goals"] += 1
			home_has_ball = true
			home_team["players"]["P"]["has_ball"] = true
	else:
		print("Interception")
		if home_has_ball:
			home_has_ball = false
			away_team["players"]["D"]["has_ball"] = true
		else:
			home_has_ball = true
			home_team["players"]["D"]["has_ball"] = true
	
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
	print(player["name"] + " passes to " + position)
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
			home_team["players"][position]["has_ball"] = true
			home_stats["pass_success"] += 1
		else:
			away_team["players"][position]["has_ball"] = true
			away_stats["pass_success"] += 1
	else:
		print("INTERCEPT")
		player["has_ball"] = false
#		emit_signal("away_pass",[position])
		home_has_ball = !home_has_ball
		_give_nearest_defender_ball(position)
	
		
	
func _get_nearest_defender(position):
	var team
	if home_has_ball:
		team = home_team["players"]
	else:
		team = away_team["players"]
	match position:
		"G":
			return team["P"]
		"D":
			return team["P"]
		"WL":
			return team["WR"]
		"WR":
			return team["WL"]
		"P":
			return team["D"]
			
func _give_nearest_defender_ball(position):
	var team
	if home_has_ball:
		match position:
			"G":
				home_team["players"]["P"]["has_ball"] = true
			"D":
				home_team["players"]["P"]["has_ball"] = true
			"WL":
				home_team["players"]["WR"]["has_ball"] = true
			"WR":
				home_team["players"]["WL"]["has_ball"] = true
			"P":
				home_team["players"]["D"]["has_ball"] = true
	else:
		match position:
			"G":
				away_team["players"]["P"]["has_ball"] = true
			"D":
				away_team["players"]["P"]["has_ball"] = true
			"WL":
				away_team["players"]["WR"]["has_ball"] = true
			"WR":
				away_team["players"]["WL"]["has_ball"] = true
			"P":
				away_team["players"]["D"]["has_ball"] = true
	
