extends Control

const VisualAction = preload("res://src/match-simulator/visual-action/VisualAction.tscn")

var home_team
var away_team

var home_goals = 0
var away_goals = 0

var last_active_view


var match_started = false

var first_half = true

onready var match_simulator = $MatchSimulator
onready var stats = $Stats

onready var animation_player = $AnimationPlayer

var speed_factor = 0

func _ready() -> void:
	var next_match = CalendarUtil.get_next_match()
	
	if next_match != null:
		for team in DataSaver.get_teams():
			if team["name"] == next_match["home"]:
				home_team = team.duplicate(true)
			elif team["name"] == next_match["away"]:
				away_team = team.duplicate(true)
	
	$HUD/TopBar/Home.text = next_match["home"]
	$HUD/TopBar/Away.text = next_match["away"]
	
	$Formation.set_up(home_team)
	match_simulator.set_up(home_team,away_team)
	
	last_active_view = $Log
	

func _process(delta) -> void:
	stats.update_stats(match_simulator.action_util.home_stats, match_simulator.action_util.away_stats)
	$HUD/TopBar/Time.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]
	
	$HUD/TimeBar.value = match_simulator.time
	
	$HUD/PossessBar.value = match_simulator.action_util.home_stats.statistics["possession"]
	
	$HUD/SpeedFactor.text = str(speed_factor + 1) + " X"
	
	$HUD/TopBar/Result.text = "%d - %d"%[home_goals,away_goals]
	

func _on_Field_pressed() -> void:
	$Log.show()
	$Stats.hide()
	last_active_view = $Log


func _on_Stats_pressed() -> void:
	$Log.hide()
	$Stats.show()
	last_active_view = $Stats


func match_end() -> void:
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
#	DataSaver.save_all_data()

func half_time() -> void:
	$HUD/Pause.text = tr("CONTINUE")



func _on_Dashboard_pressed() -> void:
	DataSaver.save_all_data()
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")


func _on_Faster_pressed() -> void:
	if speed_factor < 3:
		speed_factor += 1
		match_simulator.faster()


func _on_Slower_pressed() -> void:
	if speed_factor > 0:
		speed_factor -= 1
		match_simulator.slower()
	


func _on_Pause_pressed() -> void:
	var paused = match_simulator.pause_toggle()
	
	if paused:
		$HUD/Pause.text = tr("CONTINUE")
	else:
		$Formation.hide()
		$HUD/Pause.text = tr("PAUSE")


func _on_Formation_pressed() -> void:
	match_simulator.pause()
	$HUD/Pause.text = tr("PAUSE")
	$Formation.show()


func _on_Formation_change() -> void:
	print("change formation")
	match_simulator.change_players(home_team,away_team)


func _on_SKIP_pressed() -> void:
	match_end()


func _on_MatchSimulator_shot(is_goal, is_home) -> void:
	$HUD/Pause.disabled = true
	match_simulator.pause()
	
	$Log.hide()
	$Stats.hide()
	
	# Visual Action
	var visual_action = VisualAction.instance()
	visual_action.set_up(is_home, is_goal, home_team, away_team, $MatchSimulator/ActionUtil.action_buffer)
	$VisualActionContainer.add_child(visual_action)
	yield(visual_action, "action_finished")
	
	if is_goal:
		if is_home:
			home_goals += 1
		else:
			away_goals += 1
		
		$Goal.show()
		animation_player.play("Goal")
		yield(animation_player,"animation_finished")
		$Goal.hide()
	
	visual_action.queue_free()
	match_simulator.continue_match()
	last_active_view.show()
	$HUD/Pause.disabled = false
	

func _on_StartTimer_timeout() -> void:
	match_simulator.start_match()


func _on_MatchSimulator_half_time() -> void:
	half_time()


func _on_MatchSimulator_match_end() -> void:
	match_end()


func _on_MatchSimulator_action_message(message) -> void:
	if $Log.get_line_count() > 9:
		$Log.remove_line(0)
	$Log.newline()
	$Log.add_text($HUD/TopBar/Time.text + " " + message)
