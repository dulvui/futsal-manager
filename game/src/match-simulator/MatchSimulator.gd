extends Node2D

signal shot

# commentator mesages in log
signal action_message

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
		timer.paused = true
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
	timer.wait_time /= Constants.MATCH_SPEED_FACTOR
	
func slower():
	timer.wait_time *= Constants.MATCH_SPEED_FACTOR


func start_match():
	timer.start()
	
	# coin toss for ball
	if randi() % 2 == 1:
		action_util.home_team.has_ball = true
	else:
		action_util.away_team.has_ball = true


		
func change_players(home_team,away_team):
	action_util.change_players(home_team,away_team)


func _on_ActionUtil_action_message(message):
	emit_signal("action_message", message)

func _on_ActionUtil_shot(is_goal, is_home):
	emit_signal("shot", is_goal, is_home)
