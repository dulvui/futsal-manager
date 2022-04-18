extends Node2D

signal home_goal
signal away_goal

signal half_time
signal match_end

const HALF_TIME = 1200 # seconds for halftime

onready var action_util = $ActionUtil


var time = 0
onready var timer = $Timer

func set_up(home_team, away_team):
	action_util.set_up(home_team,away_team)

func _on_Timer_timeout():
	time += 1
	
	if time == HALF_TIME:
		timer.pause = true
		emit_signal("half_time")
	elif time == HALF_TIME * 2:
		timer.stop()
		emit_signal("match_end")
	else:
		action_util.update(time)
	
func pause_toggle():
	timer.paused = not timer.paused
	return timer.paused
	
func pause():
	timer.paused = true
	
func continue_match():
	timer.paused = false
	
func match_end():
	timer.stop()
	
func faster():
	Engine.time_scale *=  2
	Engine.iterations_per_second *= 2
	timer.wait_time /= 2
	
func slower():
	Engine.time_scale /= 2
	Engine.iterations_per_second /= 2
	timer.wait_time *=  2


func start_match():
	timer.start()
	
	# coin toss for ball
	if randi() % 2 == 1:
		action_util.home_team.has_ball = true
	else:
		action_util.away_team.has_ball = true


		
func change_players(new_home_team,new_away_team):
#	var home_players = new_home_team.duplicate(true)["players"]["active"]
#	var away_players = new_away_team.duplicate(true)["players"]["active"]
	pass
	
#	home_team.set_up(home_players,away_players,formation)
#	away_team.set_up(away_players,home_players,formation)
#	Some how change players of Team.gd
#	home_team.set_up(home_team,away_team)
#	away_team.set_up(away_team,home_team)
