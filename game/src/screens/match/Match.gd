extends Control

var home_team
var away_team

var match_started = false

var first_half = true

onready var match_simulator = $MatchSimulator

onready var animation_player = $AnimationPlayer

var speed_factor = 0

func _ready():
	var next_match = CalendarUtil.get_next_match()
	
	if next_match != null:
		for team in DataSaver.teams:
			if team["name"] == next_match["home"]:
				home_team = team
			elif team["name"] == next_match["away"]:
				away_team = team
	
	$HUD/TopBar/Home.text = next_match["home"]
	$HUD/TopBar/Away.text = next_match["away"]
	
	match_simulator.set_up(home_team,away_team)
	
	$FormationPopup/Formation/PlayerList.add_match_players()
	

func _process(delta):
	$HUD/TopBar/Time.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]
	$HUD/TopBar/Result.text = "%d - %d"%[match_simulator.action_util.home_stats.statistics["goals"],match_simulator.action_util.away_stats.statistics["goals"]]
	
	$Stats/VBoxContainer/HomePossession.text = "%d "%match_simulator.action_util.home_stats.statistics["possession"]
	$Stats/VBoxContainer/AwayPossession.text = "%d "%match_simulator.action_util.away_stats.statistics["possession"]
	$Stats/VBoxContainer/HomePass.text = "%d "%match_simulator.action_util.home_stats.statistics["pass"]
	$Stats/VBoxContainer/AwayPass.text = "%d "%match_simulator.action_util.away_stats.statistics["pass"]
	$Stats/VBoxContainer/HomePassSuccess.text = "%d "%match_simulator.action_util.home_stats.statistics["pass_success"]
	$Stats/VBoxContainer/AwayPassSuccess.text = "%d "%match_simulator.action_util.away_stats.statistics["pass_success"]
	$Stats/VBoxContainer/HomeShots.text = "%d "%match_simulator.action_util.home_stats.statistics["shots"]
	$Stats/VBoxContainer/AwayShots.text = "%d "%match_simulator.action_util.away_stats.statistics["shots"]
	$Stats/VBoxContainer/AwayShotsOnTarget.text = "%d "%match_simulator.action_util.away_stats.statistics["shots_on_target"]
	$Stats/VBoxContainer/HomeShotsOnTarget.text = "%d "%match_simulator.action_util.home_stats.statistics["shots_on_target"]
	
	$HUD/TimeBar.value = match_simulator.time
	
	$HUD/PossessBar.value = match_simulator.action_util.home_stats.statistics["possession"]
	
	$HUD/SpeedFactor.text = str(speed_factor + 1) + " X"
	
	

func _on_Field_pressed():
	match_simulator.show()
	$Stats.hide()


func _on_Stats_pressed():
	match_simulator.hide()
	$Stats.show()


func match_end():
	$Dashboard.show()
	match_simulator.match_end()
	DataSaver.save_result(home_team["name"],match_simulator.action_util.home_stats.statistics["goals"],away_team["name"],match_simulator.action_util.away_stats.statistics["goals"])
	
	#simulate all games for now. needs also support for other leagues
#	print(DataSaver.calendar[CalendarUtil.day_counter]["matches"].size())
	for matchday in DataSaver.calendar[DataSaver.month][DataSaver.day]["matches"]:
		print(matchday["home"])
		if matchday["home"] != home_team["name"]:
			print(matchday["home"] + " vs " + matchday["away"])
			DataSaver.save_result(matchday["home"],randi()%10,matchday["away"],randi()%10)

func half_time():
	$HUD/Pause.text = tr("CONTINUE")



func _on_Dashboard_pressed():
	DataSaver.save_all_data()
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")


func _on_Faster_pressed():
	if speed_factor < 3:
		speed_factor += 1
		match_simulator.faster()


func _on_Slower_pressed():
	if speed_factor > 0:
		speed_factor -= 1
		match_simulator.slower()
	


func _on_Pause_pressed():
	var paused = match_simulator.pause_toggle()
	
	if paused:
		$HUD/Pause.text = tr("CONTINUE")
	else:
		$FormationPopup.hide()
		$HUD/Pause.text = tr("PAUSE")


func _on_Formation_pressed():
	match_simulator.pause()
	$HUD/Pause.text = tr("PAUSE")
	$FormationPopup.popup_centered()


func _on_Formation_change():
	print("change formation")
	var next_match = CalendarUtil.get_next_match()
	
	if next_match != null:
		for team in DataSaver.teams:
			if team["name"] == next_match["home"]:
				home_team = team
			if team["name"] == next_match["away"]:
				away_team = team
	# need to chaneg players in simulator too
	match_simulator.change_players(home_team,away_team)
	$FormationPopup/Formation/PlayerSelect/PlayerList.add_match_players()


func _on_SKIP_pressed():
	match_end()


func _on_MatchSimulator_home_goal():
	match_simulator.pause()
	$Stats.hide() #make animation
	match_simulator.show()
	$Goal.show()
	animation_player.play("Goal")
	yield(animation_player,"animation_finished")
	$Goal.hide()
#	$Stats.show() #make animation
#	match_simulator.hide()
	match_simulator.continue_match()


func _on_MatchSimulator_away_goal():
	match_simulator.pause()
	$Stats.hide() #make animation
	match_simulator.show()
	$Goal.show()
	animation_player.play("Goal")
	yield(animation_player,"animation_finished")
	$Goal.hide()
#	$Stats.show() #make animation
#	match_simulator.hide()
	match_simulator.continue_match()


func _on_StartTimer_timeout():
	match_simulator.start_match()


func _on_MatchSimulator_half_time():
	half_time()


func _on_MatchSimulator_match_end():
	match_end()
