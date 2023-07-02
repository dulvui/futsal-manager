extends Control

signal select_player

const PlayerProfile:PackedScene = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

var team_search:String = ""
var foot_search:String = ""

var all_players:Array = []
var active_filters:Dictionary = {}

const FISICAL_TITLES:Array = ["acc","agi","jum","pac","sta","str"]

const POSITIONS:Array = ["G","D","WL","WR","P","U"]
const INFO_TYPES:Array = ["mental","physical","technical","goalkeeper"]
const FOOTS:Array = ["R","L","RL"]

@onready var table = $VBoxContainer/Table


func set_up(include_active_players:bool, active_team = null) -> void:
	
	set_up_players(include_active_players, active_team)

			
	$VBoxContainer/HBoxContainer/LeagueSelect.add_item("ITALIA")
	
	$VBoxContainer/HBoxContainer/TeamSelect.add_item("NO_TEAM")
	for team in DataSaver.get_teams():
		if team ==null or team["name"] != DataSaver.team_name:
			$VBoxContainer/HBoxContainer/TeamSelect.add_item(team["name"])
			
	$VBoxContainer/HBoxContainer/PositionSelect.add_item("NO_POS")
	for pos in POSITIONS:
		$VBoxContainer/HBoxContainer/PositionSelect.add_item(pos)
		
	$VBoxContainer/HBoxContainer/FootSelect.add_item("NO_FOOT")
	for foot in FOOTS:
		$VBoxContainer/HBoxContainer/FootSelect.add_item(foot)
		
	for info_type in INFO_TYPES:
		$VBoxContainer/HBoxContainer/InfoSelect.add_item(info_type)


func set_up_players(include_active_players, active_team = null) -> void:
	_reset_options()
	
	all_players = []
	if active_team == null:
		for team in DataSaver.get_teams():
			if include_active_players:
				for player in team["players"]["active"]:
					all_players.append(player)
			for player in team["players"]["subs"]:
				all_players.append(player)
	else:
		if include_active_players:
			for player in active_team["players"]["active"]:
				all_players.append(player)
		for player in active_team["players"]["subs"]:
			all_players.append(player)
	
	var headers = ["surname"]
	for attribute in Constants.ATTRIBUTES[INFO_TYPES[0]]:
		headers.append(attribute)
		
	table.set_up(headers, all_players.duplicate(true))
	
func remove_player(player_id) -> void:
	active_filters["id"] = player_id
	_filter_table(true)

func _on_NameSearch_text_changed(text) -> void:
	active_filters["surname"] = text
	_filter_table()


func _on_TeamSelect_item_selected(index) -> void:
	if index > 0:
		active_filters["team"] = $TeamSelect.get_item_text(index)
	else:
		active_filters["team"] = ""
	_filter_table()
	


func _on_PositionSelect_item_selected(index) -> void:
	if index > 0:
		active_filters["position"] = POSITIONS[index-1]
	else:
		active_filters["position"] = ""
	
	var headers = ["surname"]
	if active_filters["position"] == "G":
		for attribute in Constants.ATTRIBUTES["goalkeeper"]:
			headers.append(attribute)
		$InfoSelect.select(INFO_TYPES.size() - 1)
	else:
		for attribute in Constants.ATTRIBUTES[INFO_TYPES[0]]:
			headers.append(attribute)
		$InfoSelect.select(0)

	table.set_up(headers)
	_filter_table()
#
#func _on_FootSelect_item_selected(index):
#	if index > 0:
#		foot_search = FOOTS[index-1]
#	else:
#		foot_search = ""
#	add_all_players(true)

func _filter_table(exclusive = false) -> void:
	table.filter(active_filters, exclusive)

func _on_Close_pressed():
	hide()


func _on_Table_select_player(player) -> void:
	print("change in list")
	emit_signal("select_player",player)


func _on_InfoSelect_item_selected(index) -> void:
	var headers = ["surname"]
	for attribute in Constants.ATTRIBUTES[INFO_TYPES[index]]:
		headers.append(attribute)
	table.set_up(headers)
	

func _reset_options() -> void:
	$VBoxContainer/HBoxContainer/LeagueSelect.selected = 0
	$VBoxContainer/HBoxContainer/PositionSelect.selected = 0
	$VBoxContainer/HBoxContainer/TeamSelect.selected = 0
	$VBoxContainer/HBoxContainer/FootSelect.selected = 0
	$VBoxContainer/HBoxContainer/InfoSelect.selected = 0


func _on_table_info_player(player):
	var player_profile = PlayerProfile.instantiate()
	add_child(player_profile)
	player_profile.set_up_info(player)
