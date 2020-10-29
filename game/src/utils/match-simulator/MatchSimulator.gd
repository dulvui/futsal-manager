extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

signal half_time
signal match_end


const Team = preload("res://src/utils/match-simulator/actors/team/Team.gd")


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


# using 18 regions: 6 * 3
var formation = {
	"name" : "2-2",
	"home_regions" : [1,6,8,3,5],
	# add other regions
}

func _ready():
	match_timer = Timer.new()
	match_timer.wait_time = 1
	match_timer.connect("timeout",self,"update")
	add_child(match_timer)
	start_match()

func set_up(home,away):
	var home_players = home.duplicate(true)["players"]["active"]
	var away_players = away.duplicate(true)["players"]["active"]
	
	home_team = Team.new()
	away_team = Team.new()
	home_team.set_up(home_players,away_players,formation)
	away_team.set_up(away_players,home_players,formation)
	
	$BSSCalculatorAway.set_up($Field/AwayGoal)
	$BSSCalculatorHome.set_up($Field/HomeGoal)
	
	
func update():
	time += 1
	
	if time == 1200: #halftime
		pause()
		emit_signal("half_time")
	elif time == 2400:
		match_end()
		emit_signal("match_end")
	else:
		home_team.update()
		away_team.update()
	
#		if home_has_ball:
#			home_possess_counter += 1
#		home_stats["possession"] = (home_possess_counter / time) * 100
#		away_stats["possession"] = 100 - home_stats["possession"]

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
	var home_players = new_home_team.duplicate(true)["players"]["active"]
	var away_players = new_away_team.duplicate(true)["players"]["active"]
	
	home_team = Team.new()
	away_team = Team.new()
	home_team.set_up(home_players,away_players,formation)
	away_team.set_up(away_players,home_players,formation)
#	Some how change players of Team.gd
#	home_team.set_up(home_team,away_team)
#	away_team.set_up(away_team,home_team)
