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
	
	if next_match != null:
		for team in DataSaver.teams:
			if team["name"] == next_match["home"]:
				home_team = team
			if team["name"] == next_match["away"]:
				away_team = team
	
	$HUD/TopBar/Home.text = next_match["home"]
	$HUD/TopBar/Away.text = next_match["away"]
	
	$MatchSimulator.set_up(home_team,away_team)
	$Field.set_numbers(home_team["players"],away_team["players"])
	
	$FormationPopup/Formation/PlayerSelect/PlayerList.add_match_players()
	
#	match_end()
	

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
	

func _on_Timer_timeout():
	$Field.random_pass()
	$MatchSimulator.update_time()
	
	if $MatchSimulator.time == 1200:
		half_time()
	elif $MatchSimulator.time == 2400:
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
	DataSaver.save_result(home_team["name"],$MatchSimulator.home_stats["goals"],away_team["name"],$MatchSimulator.away_stats["goals"])
	
	#simulate all games for now. needs also support for other leagues
	print(DataSaver.calendar[CalendarUtil.day_counter]["matches"].size())
	for matchday in DataSaver.calendar[CalendarUtil.day_counter]["matches"]:
		print(matchday["home"])
		if matchday["home"] != home_team["name"]:
			print(matchday["home"] + " vs " + matchday["away"])
			DataSaver.save_result(matchday["home"],randi()%10,matchday["away"],randi()%10)

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
		$FormationPopup.hide()
		$HUD/Pause.text = tr("PAUSE")


func _on_Formation_pressed():
	$Timer.paused = true
	$TimerMatchSimulator.paused = true
	$HUD/Pause.text = tr("PAUSE")
	$FormationPopup.popup_centered()


func _on_Formation_change():
	print("change numebrs")
	var next_match = CalendarUtil.get_next_match()
	
	if next_match != null:
		for team in DataSaver.teams:
			if team["name"] == next_match["home"]:
				home_team = team
				print(home_team["players"]["G"])
			if team["name"] == next_match["away"]:
				away_team = team
	# need to chaneg players in simulator too
	$MatchSimulator.change_players(home_team,away_team)
	
	$FormationPopup/Formation/PlayerSelect/PlayerList.add_match_players()
	$Field.set_numbers(home_team["players"],away_team["players"])

	


func _on_SKIP_pressed():
	match_end()
