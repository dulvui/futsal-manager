extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

const Player = preload("res://src/screens/match/field/player/Player.tscn")
const Ball = preload("res://src/screens/match/field/ball/Ball.tscn")

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

var ball



func _ready():
	ball = Ball.instance()
	ball.position = Vector2(500,500)
	add_child(ball)

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
	

func update():
	time += 1
	if home_has_ball:
		home_possess_counter += 1
	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]
	
	
	# add pos to update_decision
	for player in home_team["players"]["active"]:
		player["real"].update_decision(home_has_ball,player["has_ball"])
		
	for player in away_team["players"]["active"]:
		player["real"].update_decision(!home_has_ball,player["has_ball"])


func _on_GameField_body_exited(body):
	print("ball exits field")
	ball.queue_free()
	ball = Ball.instance()
	ball.position = Vector2(500,500)
	add_child(ball)



