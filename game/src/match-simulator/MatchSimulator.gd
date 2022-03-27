extends Node2D

signal home_goal
signal away_goal

signal half_time
signal match_end

const HALF_TIME = 1200 # seconds for halftime

onready var home_team = $HomeTeam
onready var away_team = $AwayTeam
onready var action_util = $ActionUtil


var time = 0
onready var timer = $Timer

func _ready():
	action_util.set_up(home_team,away_team)

func _update_game():
	home_team.update_stats(time)
	away_team.update_stats(time)
	
	action_util.update()
	
func pause_toggle():
	timer.paused = not timer.paused
	return timer.paused
	
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
		home_team.has_ball = true
	else:
		away_team.has_ball = true
	
	home_team.set_up()
	away_team.set_up()


func _on_Timer_timeout():
	time += 1
	
	if time == HALF_TIME:
		timer.pause = true
		emit_signal("half_time")
	elif time == HALF_TIME * 2:
		timer.stop()
		emit_signal("match_end")
	else:
		_update_game()
