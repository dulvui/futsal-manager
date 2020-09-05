extends Control

var home_team
var away_team

var match_started = false

var first_half = true

var paused = false

var speed_factor = 2

func _ready():
#	home_team = matchz["home"]["players"].duplicate(true)
#	away_team = matchz["away"]["players"].duplicate(true)

	var next_match = CalendarUtil.get_next_match()
	
	for team in DataSaver.teams:
		if team["name"] == next_match["home"]:
			home_team = team
		if team["name"] == next_match["away"]:
			away_team = team
	
	$HUD/TopBar/Home.text = next_match["home"]
	$HUD/TopBar/Away.text = next_match["away"]
	
	$MatchSimulator.set_up(home_team,away_team)
	$HalfTimeTimer.start()

func _process(delta):
	$HUD/TopBar/Time.text = "%02d:%02d"%[int($MatchSimulator.time)/60,int($MatchSimulator.time)%60]
	$HUD/TopBar/Result.text = "%d - %d"%[$MatchSimulator.home_stats["goals"],$MatchSimulator.away_stats["goals"]]
	
	$Stats/VBoxContainer/HomePossession.text = "%d "%$MatchSimulator.home_stats["possession"]
	$Stats/VBoxContainer/AwayPossession.text = "%d "%$MatchSimulator.away_stats["possession"]
	$Stats/VBoxContainer/HomePass.text = "%d "%$MatchSimulator.home_stats["pass"]
	$Stats/VBoxContainer/AwayPass.text = "%d "%$MatchSimulator.away_stats["pass"]
	$Stats/VBoxContainer/HomePassSuccess.text = "%d "%$MatchSimulator.home_stats["pass_success"]
	$Stats/VBoxContainer/AwayPassSuccess.text = "%d "%$MatchSimulator.away_stats["pass_success"]
	$Stats/VBoxContainer/HomeShots.text = "%d "%$MatchSimulator.home_stats["shots"]
	$Stats/VBoxContainer/AwayShots.text = "%d "%$MatchSimulator.away_stats["shots"]
	
	$HUD/TimeBar.value = $MatchSimulator.time
	
	$HUD/PossessBar.value = $MatchSimulator.home_stats["possession"]
	
	$HUD/TopBar/SpeedFactor.text = str(speed_factor + 1) + " X"
	


func set_up(matchz):
	home_team = matchz["home"]["players"].duplicate(true)
	away_team = matchz["away"]["players"].duplicate(true)

func _on_Timer_timeout():
	$Field.random_pass()
	$MatchSimulator.update_time()
	
	if $MatchSimulator.time == 1800:
		half_time()
	elif $MatchSimulator.time == 3600:
		match_end()
	
	
func _on_TimerMatchSimulator_timeout():
	$MatchSimulator.update()
	

func _on_Field_pressed():
	$Field.show()
	$Stats.hide()


func _on_Stats_pressed():
	$Field.hide()
	$Stats.show()



func _on_MatchSimulator_away_pass(position):
#	$Field.home_pass_to(position)
	pass

func _on_MatchSimulator_home_pass():
#	$Field.away_pass_to(position)
	pass

func match_end():
	$Dashboard.show()
	$Timer.stop()
	$TimerMatchSimulator.stop()
	


func half_time():
	_on_Pause_pressed()



func _on_Dashboard_pressed():
	DataSaver.save_all_data()
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")


func _on_Faster_pressed():
	if speed_factor < 4:
		$Timer.wait_time /= 2
		$TimerMatchSimulator.wait_time = $Timer.wait_time * 5
		speed_factor += 1


func _on_Slower_pressed():
	if speed_factor > 0:
		$Timer.wait_time *= 2
		$TimerMatchSimulator.wait_time = $Timer.wait_time * 5
		speed_factor -= 1
	


func _on_Pause_pressed():
	$Timer.paused = not $Timer.paused
	$TimerMatchSimulator.paused = not $TimerMatchSimulator.paused
	
	if $Timer.paused:
		$HUD/Pause.text = tr("CONTINUE")
	else:
		$HUD/Pause.text = tr("PAUSE")
