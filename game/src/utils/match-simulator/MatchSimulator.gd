extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

signal half_time
signal match_end


const Team = preload("res://src/utils/match-simulator/simulator-team/SimulatorTeam.gd")


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

var time = 0.0

var home_possess_counter = 0.0

var match_timer

var home_has_ball = true


# simple soccer

var field
var home_goal
var away_goal

# type of SimulatorTeam.gd
var home_team
var away_team

func _ready():
	match_timer = Timer.new()
	match_timer.wait_time = 1
	match_timer.connect("timeout",self,"update")
	add_child(match_timer)
	start_match()

func set_up(home,away, match_started):
	home_team = home.duplicate(true)
	away_team = away.duplicate(true)
	
	
func update():
	time += 1
	
	if time == 1200: #halftime
		pause()
		emit_signal("half_time")
	elif time == 2400:
		match_end()
		emit_signal("match_end")
	else:
	
	
		if home_has_ball:
			home_possess_counter += 1
		home_stats["possession"] = (home_possess_counter / time) * 100
		away_stats["possession"] = 100 - home_stats["possession"]

func start_match():
	match_timer.start()
	
func pause():
	match_timer.paused = true
	
func continue_match():
	match_timer.paused = false
	
func pause_toggle():
	match_timer.paused = not match_timer.paused
	return match_timer.paused
	

func match_end():
	match_timer.stop()
	
func faster():
	match_timer.wait_time = match_timer.wait_time / 2
	
func slower():
	match_timer.wait_time = match_timer.wait_time * 2
	
				
func change_players(new_home_team,new_away_team):
	home_team = new_home_team.duplicate(true)
	away_team = new_away_team.duplicate(true)
	
	for i in range(home_team["players"]["active"].size()):
		var player = home_team["players"]["active"][i]
		player["has_ball"]  = false
		player["home"]  = true
		player["real"] = create_real_player(player,i)

	for i in range(away_team["players"]["active"].size()):
		var player = away_team["players"]["active"][i]
		player["has_ball"]  = false
		player["home"]  = false
		player["real"] = create_real_player(player,i)
	
	
	#make better and look who has ball after interruption
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["active"][4]["has_ball"] = true
	else:
		away_team["players"]["active"][4]["has_ball"] = true

func create_real_player(player,pos):
	var real_player = Player.new()
	match pos:
		0:
			real_player.set_up(player,Vector2(100,300),pos)
		1:
			real_player.set_up(player,Vector2(250,300),pos)
		2:
			real_player.set_up(player,Vector2(350,100),pos)
		3:
			real_player.set_up(player,Vector2(350,500),pos)
		4:
			real_player.set_up(player,Vector2(500,300),pos)
				
	real_player.connect("pass_to",self,"pass_to")
	real_player.connect("shoot",self,"shoot")
	real_player.connect("dribble",self,"dribble")
	add_child(real_player)
	return real_player
