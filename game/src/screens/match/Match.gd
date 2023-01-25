extends Control

const VisualAction:PackedScene = preload("res://src/match-simulator/visual-action/VisualAction.tscn")

onready var match_simulator:Node2D = $MatchSimulator
onready var stats:MarginContainer = $Stats
onready var comments:RichTextLabel = $Log
onready var events:ScrollContainer = $Events
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var time_label:Label = $HUD/TopBar/Time
onready var result_label:Label = $HUD/TopBar/Result

var last_active_view:Control

var home_team:Dictionary
var away_team:Dictionary

# to acces player data
var home_team_real:Dictionary
var away_team_real:Dictionary

var home_goals:int = 0
var away_goals:int = 0
var speed_factor:int = 0

var match_started:bool = false
var first_half:bool = true


func _ready() -> void:
	randomize()
	var next_match:Dictionary = CalendarUtil.get_next_match()
	
	if next_match != null:
		for team in DataSaver.get_teams():
			if team["name"] == next_match["home"]:
				home_team_real = team
				home_team = team.duplicate(true)
			elif team["name"] == next_match["away"]:
				away_team_real = team
				away_team = team.duplicate(true)
	
	$HUD/TopBar/Home.text = next_match["home"]
	$HUD/TopBar/Away.text = next_match["away"]
	
	$Formation.set_up()
	match_simulator.set_up(home_team,away_team)
	
	last_active_view = comments
	

func _process(delta:float) -> void:
	stats.update_stats(match_simulator.action_util.home_stats.statistics, match_simulator.action_util.away_stats.statistics)
	time_label.text = "%02d:%02d"%[int(match_simulator.time)/60,int(match_simulator.time)%60]
	
	$HUD/TimeBar.value = match_simulator.time
	$HUD/PossessBar.value = match_simulator.action_util.home_stats.statistics["possession"]
	$HUD/SpeedFactor.text = str(speed_factor + 1) + " X"


func match_end() -> void:
	$HUD/Faster.hide()
	$HUD/Slower.hide()
	$HUD/Pause.hide()
	$HUD/SpeedFactor.hide()
	$Dashboard.show()
	match_simulator.match_end()
	DataSaver.set_table_result(home_team["name"],match_simulator.action_util.home_stats.statistics["goals"],away_team["name"],match_simulator.action_util.away_stats.statistics["goals"])
	
	
	#simulate all games for now.
	for matchday in DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"]:
		if matchday["home"] != home_team["name"]:
			var random_home_goals = randi()%10
			var random_away_goals = randi()%10
			
			matchday["result"] = str(random_home_goals) + ":" + str(random_away_goals)
			print(matchday["home"] + " vs " + matchday["away"])
			DataSaver.set_table_result(matchday["home"],random_home_goals,matchday["away"],random_away_goals)
		else:
			matchday["result"] = str(match_simulator.action_util.home_stats.statistics["goals"]) + ":" + str(match_simulator.action_util.away_stats.statistics["goals"])
#	DataSaver.save_all_data()

	#save players history PoC
	for real_player in home_team_real["players"]["active"]:
		for copy_player in home_team["players"]["active"]:
			if real_player["nr"] == copy_player["nr"]:
				real_player["history"][DataSaver.current_season]["actual"] = copy_player["history"][DataSaver.current_season]["actual"]
					
	for real_player in away_team_real["players"]["active"]:
		for copy_player in away_team["players"]["active"]:
			if real_player["nr"] == copy_player["nr"]:
				real_player["history"][DataSaver.current_season]["actual"] = copy_player["history"][DataSaver.current_season]["actual"]

func half_time() -> void:
	$HUD/Pause.text = tr("CONTINUE")


func _on_Field_pressed() -> void:
	_hide_views()
	comments.show()
	last_active_view = comments


func _on_Stats_pressed() -> void:
	_hide_views()
	stats.show()
	last_active_view = stats
	

func _on_Events_pressed() -> void:
	_hide_views()
	events.show()
	last_active_view = events
	
func _hide_views() -> void:
	comments.hide()
	stats.hide()
	events.hide()

func _toggle_view_buttons() -> void:
	$HUD/LeftButtons/Change.disabled = not $HUD/LeftButtons/Change.disabled 
	$HUD/LeftButtons/Events.disabled = not $HUD/LeftButtons/Events.disabled
	$HUD/LeftButtons/Stats.disabled = not $HUD/LeftButtons/Stats.disabled
	$HUD/LeftButtons/Field.disabled = not $HUD/LeftButtons/Field.disabled
	$HUD/LeftButtons/Formation.disabled = not $HUD/LeftButtons/Formation.disabled
	$HUD/LeftButtons/Tactics.disabled = not $HUD/LeftButtons/Tactics.disabled
	

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
	var paused:bool = match_simulator.pause_toggle()
	
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
	match_simulator.change_players(home_team,away_team)


func _on_SKIP_pressed() -> void:
	match_end()


func _on_MatchSimulator_shot(is_goal:bool, is_home:bool, player:Object) -> void:
	if not is_goal and randi() % Constants.VISUAL_ACTION_SHOTS_FACTOR > 0:
		# no goal, but show some shoots
		return
	
	# show visual action
	$HUD/Pause.disabled = true
	match_simulator.pause()
	_hide_views()
	_toggle_view_buttons()
	
	# Visual Action
	var visual_action:Node = VisualAction.instance()
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
		
		result_label.text = "%d - %d"%[home_goals,away_goals]
		
		events.append_text("%s  %s - %s  %s" % [time_label.text, str(home_goals), str(away_goals), player["profile"]["name"]])

	
	visual_action.queue_free()
	match_simulator.continue_match()
	last_active_view.show()
	$HUD/Pause.disabled = false
	_toggle_view_buttons()
	

func _on_StartTimer_timeout() -> void:
	match_simulator.start_match()


func _on_MatchSimulator_half_time() -> void:
	half_time()


func _on_MatchSimulator_match_end() -> void:
	match_end()


func _on_MatchSimulator_action_message(message:String) -> void:
	if comments.get_line_count() > 9:
		comments.remove_line(0)
	comments.newline()
	comments.add_text(time_label.text + " " + message)
