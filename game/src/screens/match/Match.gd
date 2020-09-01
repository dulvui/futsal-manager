extends Control

var home_team
var away_team

var match_started = false



func _process(delta):
	$HUD/TopBar/Time.text = "%02d:%02d"%[int($MatchSimulator.time)/60,int($MatchSimulator.time)%60]
	$HUD/TopBar/Result.text = "%d - %d"%[$MatchSimulator.home_stats["goals"],$MatchSimulator.away_stats["goals"]]
	
	$Stats/VBoxContainer/HomePossession.text = "%d "%$MatchSimulator.home_stats["possession"]
	$Stats/VBoxContainer/AwayPossession.text = "%d "%$MatchSimulator.away_stats["possession"]
	
	$HUD/TimeBar.value = $MatchSimulator.time
	
	$HUD/PossessBar.value = $MatchSimulator.home_stats["possession"]
	


func set_up(matchz):
	home_team = matchz["home"]["players"].duplicate(true)
	away_team = matchz["away"]["players"].duplicate(true)
	$MatchSimulator.set_up(null,null)

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
