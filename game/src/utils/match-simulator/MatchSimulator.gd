extends Node


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


func _ready():
	var base_players = DataSaver.team
	
	home_team = base_players.duplicate(true)
	away_team = base_players.duplicate(true)
	
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["P"]["has_ball"] = true
	else:
		away_team["players"]["P"]["has_ball"] = true

func set_up(home,away):
	var base_players = DataSaver.selected_players.duplicate(true)
	
	for player in base_players:
		player["has_ball"] = false
	
	home_team = base_players.duplicate(true)
	away_team = base_players.duplicate(true)
	
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team[4]["has_ball"] = true
	else:
		away_team[4]["has_ball"] = true
			
			
			
func update():
	time += 1
	
	_make_home_decisions()
	_make_away_decisions()
	
	if home_has_ball:
		home_possess_counter += 1

	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]
	
	
func _make_home_decisions():
	if home_has_ball:
		_make_offensive_decision(home_team["players"]["G"],"G")
		_make_offensive_decision(home_team["players"]["D"],"D")
		_make_offensive_decision(home_team["players"]["WL"],"WL")
		_make_offensive_decision(home_team["players"]["WR"],"WR")
		_make_offensive_decision(home_team["players"]["P"],"P")
	else:
		_make_defensive_decision(home_team["players"]["G"],"G")
		_make_defensive_decision(home_team["players"]["D"],"D")
		_make_defensive_decision(home_team["players"]["WL"],"WL")
		_make_defensive_decision(home_team["players"]["WR"],"WR")
		_make_defensive_decision(home_team["players"]["P"],"P")
		
func _make_away_decisions():
	if not home_has_ball:
		_make_offensive_decision(away_team["players"]["G"],"G")
		_make_offensive_decision(away_team["players"]["D"],"D")
		_make_offensive_decision(away_team["players"]["WL"],"WL")
		_make_offensive_decision(away_team["players"]["WR"],"WR")
		_make_offensive_decision(away_team["players"]["P"],"P")
	else:
		_make_defensive_decision(away_team["players"]["G"],"WL")
		_make_defensive_decision(away_team["players"]["D"],"D")
		_make_defensive_decision(away_team["players"]["WL"],"WL")
		_make_defensive_decision(away_team["players"]["WR"],"WR")
		_make_defensive_decision(away_team["players"]["P"],"P")

func _make_offensive_decision(player,pos):
	if player["has_ball"]:
		print(player["name"] + " has ball")
		var decision = _what_offensive_decision(player,pos) # make it affected by tactic, formation and in which sector player is
		match decision:
			"PASS":
				print(" and passes the ball")
				_pass_to(player,POS[randi()%POS.size()])
			"SHOOT":
				print(" and shoots the ball")
				_shoot(player)
			"DRIBBLE":
				print(" and dribbles")
				_dribble(player)
			"MOVE":
				print(" and moves")
				_move_with_ball(player)
			"WAIT":
				print(" and waits")
				_wait(player)
				
	else:
		_make_defensive_decision(player,pos) # or wait, depending on workrate, teamwork, defensive/offensive movement

func _what_offensive_decision(player,pos):
	var decision 
	var o1 = randi()%20
	
	match pos:
		"G":
			if home_has_ball:
				if o1 < home_team["offensive_tactics"]["O1"]:
					#possession
					# pass to defender
					pass
				else:
					#fast attack
					#pass to wings or pivot
					pass
		"D":
			if home_has_ball:
				if o1 < home_team["offensive_tactics"]["O1"]:
					#possession
					# pass to winger o goalie
					pass
				else:
					#fast attack
					#pass to wing or pivot, keypass
					pass
		"WL":
			if home_has_ball:
				if o1 < home_team["offensive_tactics"]["O1"]:
					#possession
					# pass to defender, or winger o goalie
					pass
				else:
					#fast attack
					#pass to wing or pivot, keypass, dribble
					pass
		"WR":
			if home_has_ball:
				if o1 < home_team["offensive_tactics"]["O1"]:
					#possession
					# pass to defender, or winger o goalie
					pass
				else:
					#fast attack
					#pass to wing or pivot, keypass, dribble
					pass
		"P":
			if home_has_ball:
				if o1 < home_team["offensive_tactics"]["O1"]:
					#possession
					# pass winger, low probabilty of shot
					pass
				else:
					#fast attack
					#shoot, pass to wingers, key pass, dribble
					pass
		
	return "PASS"
	return decision
	

func _make_defensive_decision(player,pos):
	_move(player)

func _move(player):
	pass
	
func _move_with_ball(player):
	pass
	
func _shoot(player):
	pass
	
func _dribble(player):
	pass
	
func _wait(player):
	pass
	
func _pass_to(player,position):
	print(player["name"] + " passes to " + position)
	player["has_ball"] = false
	if home_has_ball:
		print("short pass")
		var pass_stats 
		
		var is_short = randi()%20 < home_team["offensive_tactics"]["O1"]
		
		if is_short:
			pass_stats = player["stats"]["technial"]["pass"]
		else:
			pass_stats = player["stats"]["technial"]["long_pass"]
		
		var nearest_defender = away_team["players"][_get_nearest_defender(position)]
		var defender_stats = nearest_defender["stats"]["technial"]["marking"]
		var will_do_pressing = randi()%20 > away_team["defensive_tactics"]["D1"]
		
		if will_do_pressing:
			#reduce stamina
			pass
		
		var result = randi()% pass_stats + defender_stats
		
		if result <= pass_stats:
			print("SUCCESS")
			home_team["players"][position]["has_ball"] = true
		else:
			print("INTERCEPT")
			print("posses change")
			home_has_ball = false
			nearest_defender["has_ball"] = true
	else:
		print("short pass")
		var pass_stats 
		
		var is_short = randi()%20 < away_team["offensive_tactics"]["O1"]
		
		if is_short:
			pass_stats = player["stats"]["technial"]["pass"]
		else:
			pass_stats = player["stats"]["technial"]["long_pass"]
		
		var nearest_defender = home_team["players"][_get_nearest_defender(position)]
		var defender_stats = nearest_defender["stats"]["technial"]["marking"]
		var will_do_pressing = randi()%20 > home_team["defensive_tactics"]["D1"]
		
		if will_do_pressing:
			#reduce stamina
			pass
		
		var result = randi()% (pass_stats + defender_stats)
		
		print("pass %s vs mark %s = %s"%[str(pass_stats),str(defender_stats),str(result)])
		
		if result <= pass_stats:
			print("SUCCESS")
			away_team["players"][position]["has_ball"] = true
		else:
			print("INTERCEPT")
			print("posses change")
			home_has_ball = true
			nearest_defender["has_ball"] = true
		
	
func _get_nearest_defender(position):
	match position:
		"G":
			return "P"
		"D":
			return "P"
		"WL":
			return "WR"
		"WR":
			return "WL"
		"P":
			return "D"
