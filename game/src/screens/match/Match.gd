extends Control

var home_team
var away_team

var match_started = false

var first_half = true

func _ready():
#	home_team = matchz["home"]["players"].duplicate(true)
#	away_team = matchz["away"]["players"].duplicate(true)

	var next_match = CalendarUtil.get_next_match()
	
	for team in DataSaver.teams:
		if team["name"] == next_match["home"]:
			home_team = team
		if team["name"] == next_match["away"]:
			away_team = team
	print(home_team)
	
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
	


func set_up(matchz):
	home_team = matchz["home"]["players"].duplicate(true)
	away_team = matchz["away"]["players"].duplicate(true)
#	$MatchSimulator.set_up(null,null)

func _on_Timer_timeout():
	$Field.random_pass()
	$MatchSimulator.update_time()
	

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


func _on_TimerMatchSimulator_timeout():
	$MatchSimulator.update()


func _on_HalfTimeTimer_timeout():
	if first_half:
		first_half = false
		$NextHalf.show()

	$Timer.stop()
	$TimerMatchSimulator.stop()


func _on_NextHalf_pressed():
	$HalfTimeTimer.start()
	$Timer.start()
	$TimerMatchSimulator.start()
