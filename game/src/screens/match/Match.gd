extends Control

var home_team
var away_team

var match_started = false

var home_possess = false
var away_possess = false
var home_possess_counter = 0.0
var away_possess_counter = 0.0

var time = 0.0 # time in seconds
var supplement_time = 0


func _process(delta):
	$HUD/TopBar/Time.text = "%02d:%02d"%[int(time)/60,int(time)%60]
	$HUD/TopBar/Result.text = "%d - %d"%[MatchSimluator.home_stats["goals"],MatchSimluator.away_stats["goals"]]
	
	$Stats/VBoxContainer/HomePossession.text = "%d "%MatchSimluator.home_stats["possession"]
	$Stats/VBoxContainer/AwayPossession.text = "%d "%MatchSimluator.away_stats["possession"]


func set_up(matchz):
	home_team = matchz["home"]["players"].duplicate(true)
	away_team = matchz["away"]["players"].duplicate(true)

func _on_Timer_timeout():
	time += 1
	if not match_started:
		if randi() % 2:
			home_possess = true
			home_possess_counter += 1
		else:
			away_possess = true
			away_possess_counter += 1
		match_started = true
	else:
		if home_possess:
			home_possess_counter += 1
			
		else:
			away_possess_counter += 1
			
	MatchSimluator.update()
#	_set_stats()
#
#
#	$Field.random_pass()
	

func _on_Field_pressed():
	$Field.show()
	$Stats.hide()


func _on_Stats_pressed():
	$Field.hide()
	$Stats.show()

