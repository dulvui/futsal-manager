extends Control

const VisualAction = preload("res://src/match-simulator/visual-action/VisualAction.tscn")

var home_team
var away_team

var home_goals = 0
var away_goals = 0


var match_started = false

var first_half = true

onready var match_simulator = $MatchSimulator
onready var stats = $Stats

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
	stats.update_stats(match_simulator.action_util.home_stats, match_simulator.action_util.away_stats)
	$HUD/TopBar/Time.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]
	
	$HUD/TimeBar.value = match_simulator.time
	
	$HUD/PossessBar.value = match_simulator.action_util.home_stats.statistics["possession"]
	
	$HUD/SpeedFactor.text = str(speed_factor + 1) + " X"
	
	$HUD/TopBar/Result.text = "%d - %d"%[home_goals,away_goals]
	

func _on_Field_pressed():
	$Log.show()
	$Stats.hide()


func _on_Stats_pressed():
	$Log.hide()
	$Stats.show()


func match_end():
	$HUD/Faster.hide()
	$HUD/Slower.hide()
	$HUD/Pause.hide()
	$HUD/SpeedFactor.hide()
	$Dashboard.show()
	match_simulator.match_end()
	DataSaver.set_table_result(home_team["name"],match_simulator.action_util.home_stats.statistics["goals"],away_team["name"],match_simulator.action_util.away_stats.statistics["goals"])
	
	
	#simulate all games for now.
	for matchday in DataSaver.calendar[DataSaver.date.month][DataSaver.date.day - 1]["matches"]:
		if matchday["home"] != home_team["name"]:
			var home_goals = randi()%10
			var away_goals = randi()%10
			
			matchday["result"] = str(home_goals) + ":" + str(away_goals)
			print(matchday["home"] + " vs " + matchday["away"])
			DataSaver.set_table_result(matchday["home"],home_goals,matchday["away"],away_goals)
		else:
			matchday["result"] = str(match_simulator.action_util.home_stats.statistics["goals"]) + ":" + str(match_simulator.action_util.away_stats.statistics["goals"])
	DataSaver.save_all_data()

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
	
	$Log.hide()
	$Stats.hide()
	var visual_action = VisualAction.instance()
	$VisualActionContainer.add_child(visual_action)
	visual_action.set_up(false, true)
	yield(visual_action, "action_finished")
	
	home_goals += 1
	
	$Goal.show()
	animation_player.play("Goal")
	yield(animation_player,"animation_finished")
	$Goal.hide()
	visual_action.queue_free()
	match_simulator.continue_match()
	$Log.show()
	
func _on_MatchSimulator_away_goal():
	match_simulator.pause()

	$Log.hide()
	$Stats.hide()
	var visual_action = VisualAction.instance()
	$VisualActionContainer.add_child(visual_action)
	visual_action.set_up(true, true)
	yield(visual_action, "action_finished")
	
	away_goals += 1
	
	$Goal.show()
	animation_player.play("Goal")
	yield(animation_player,"animation_finished")
	$Goal.hide()
	visual_action.queue_free()
	match_simulator.continue_match()
	$Log.show()
	
func _on_MatchSimulator_home_shot():
	match_simulator.pause()
	
	$Log.hide()
	$Stats.hide()
	var visual_action = VisualAction.instance()
	$VisualActionContainer.add_child(visual_action)
	visual_action.set_up(false, false)
	yield(visual_action, "action_finished")
	
	visual_action.queue_free()
	match_simulator.continue_match()
	$Log.show()

func _on_MatchSimulator_away_shot():
	match_simulator.pause()
	
	$Log.hide()
	$Stats.hide()
	var visual_action = VisualAction.instance()
	$VisualActionContainer.add_child(visual_action)
	visual_action.set_up(true, false)
	yield(visual_action, "action_finished")
	
	visual_action.queue_free()
	match_simulator.continue_match()
	$Log.show()
	

func _on_StartTimer_timeout():
	match_simulator.start_match()


func _on_MatchSimulator_half_time():
	half_time()


func _on_MatchSimulator_match_end():
	match_end()


func _on_MatchSimulator_action_message(message):
	$Log.add_text($HUD/TopBar/Time.text + " " + message + "\n")





