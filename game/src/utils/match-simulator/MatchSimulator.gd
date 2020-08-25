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

var home_has_ball

func set_up(home,away):
	home_team = home_team
	away_team = away_team
	
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["P"]["has_ball"] = true
	else:
		away_team["players"]["P"]["has_ball"] = true
			
			
			
func update():
	
	for player in home_team["players"]:
		if home_has_ball:
			_make_offensive_decision(player)
		else:
			_make_defensive_decision(player)
		
	for player in home_team["players"]:
		if not home_has_ball:
			_make_offensive_decision(player)
		else:
			_make_defensive_decision(player)
	
	
func _make_offensive_decision(player):
	if player["has_ball"]:
		pass # see tatcits and fomration to make decision
	else:
		_move(player)
		
func _make_defensive_decision(player):
	_move(player)

func _move(player):
	pass
	
	

