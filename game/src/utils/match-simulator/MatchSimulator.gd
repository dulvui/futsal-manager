extends Node


var home_team = []
var away_team = []

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


var home_has_ball

func _ready():
	var base_players = _get_actual_players(DataSaver.team)
	
	for player in base_players:
		player["has_ball"] = false
	
	home_team = base_players.duplicate(true)
	away_team = base_players.duplicate(true)
	
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team[4]["has_ball"] = true
	else:
		away_team[4]["has_ball"] = true

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
	for player in home_team:
		if home_has_ball:
			_make_offensive_decision(player)
		else:
			_make_defensive_decision(player)
		
	for player in away_team:
		if not home_has_ball:
			_make_offensive_decision(player)
		else:
			_make_defensive_decision(player)
			
	if home_has_ball:
		home_possess_counter += 1
		
	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]
	
	
func _make_offensive_decision(player):
	if player["has_ball"]:
		print(player["name"] + " has ball")
		var decision = _what_decision(player) # make it affected by tactic, formation and in which sector player is
		match decision:
			"PASS":
				print(" and passes the ball")
				_pass_to(player,home_team[randi()%home_team.size()])
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
		_move(player) # or wait, depending on workrate, teamwork, defensive/offensive movement

func _what_decision(player):
	var decision 
	
#	if home_team["tactic"]
	
	return decision
	

func _make_defensive_decision(player):
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
	
func _pass_to(player,player_to):
	var success = false
	print(player["name"] + " passes to " + player_to["name"])
	player["has_ball"] = false
	player_to["has_ball"] = true
	
	return success
	
	
func _get_actual_players(team):
	var actual_players = []
	for player in team["players"]:
		if player["actual_pos"] != "S":
			actual_players.append(player)
	return actual_players
