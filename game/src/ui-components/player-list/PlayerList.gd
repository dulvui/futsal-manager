extends Control

signal select_player

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

var name_search = ""
var team_search = ""
var position_search = ""
var foot_search = ""

var current_page = 0

var all_players = []
var current_players = []

var info_type = "GENERAL"

const POSITIONS = ["G","D","WL","WR","P","U"]
const INFO_TYPES = ["GENERAL","FISICAL","MENTAL"]
const FOOTS = ["R","L","RL"]

func _ready():
	for team in DataSaver.teams:
		if team["name"] != DataSaver.selected_team:
			for player in team["players"]["active"]:
				all_players.append(player)
				current_players.append(player)
			for player in team["players"]["subs"]:
				all_players.append(player)
				current_players.append(player)
			
	$LegaueSelect.add_item("ITALIA")
	
	$TeamSelect.add_item("NO_TEAM")
	for team in DataSaver.teams:
		if team["name"] != DataSaver.selected_team:
			$TeamSelect.add_item(team["name"])
			
	$PositionSelect.add_item("NO_POS")
	for pos in POSITIONS:
		$PositionSelect.add_item(pos)
		
	$FootSelect.add_item("NO_FOOT")
	for foot in FOOTS:
		$FootSelect.add_item(foot)
	
	for info_type in INFO_TYPES:
		$InfoSelect.add_item(info_type)
		
	$Paginator/PageCounter.text = str(current_page + 1) + "/" + str(current_players.size()/10 + 1)
	


func add_subs():
	for child in $CurrentPlayers.get_children():
		child.queue_free()
		
	$TeamSelect.hide()
	$LegaueSelect.hide()
	
#	if filter:
	current_players = []
	current_page = 0
	
	var team = DataSaver.get_selected_team()
	for player in team["players"]["subs"]:
		if filter_player(player):
			current_players.append(player)
				
	for player in current_players.slice(current_page*10,((current_page + 1) * 10)-1):
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		player_profile.set_up_info(player,info_type)
		$CurrentPlayers.add_child(player_profile)
	
		
func add_match_players():
	for child in $CurrentPlayers.get_children():
		child.queue_free()
	
	$TeamSelect.hide()
	$LegaueSelect.hide()
	var team = DataSaver.get_selected_team()
	for player in team["players"]["active"]:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$CurrentPlayers.add_child(player_profile)
		player_profile.set_up_info(player,info_type)
	
	for player in team["players"]["subs"].slice(0,9):
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$CurrentPlayers.add_child(player_profile)
		player_profile.set_up_info(player,info_type)
	
		
func add_all_players(filter):
	for child in $CurrentPlayers.get_children():
		child.queue_free()
		
	if filter:
		current_players = []
		current_page = 0
		for player in all_players:
			if filter_player(player):
				current_players.append(player)
				
	for player in current_players.slice(current_page*10,((current_page + 1) * 10)-1):
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		player_profile.set_up_info(player,info_type)
		$CurrentPlayers.add_child(player_profile)
		
	$Paginator/PageCounter.text = str(current_page + 1) + "/" + str(current_players.size()/10 + 1)
	
	

func select_player(player):
	print("change in lst")
	emit_signal("select_player",player)
		
func filter_player(player):
	if name_search.length() == 0 or name_search.to_upper() in player["surname"].to_upper():
		if team_search.length() == 0 or team_search == player["team"]:
			if team_search.length() == 0 or team_search == player["team"]:
				if position_search.length() == 0 or position_search == player["position"]:
					if foot_search.length() == 0 or foot_search == player["foot"]:
						return true
	return false

func _on_NameSearch_text_changed(new_text):
	name_search = new_text
	add_all_players(true)


func _on_TeamSelect_item_selected(index):
	var teams = []
	for team in DataSaver.teams:
		if team["name"] != DataSaver.selected_team:
			teams.append(team)
	
	if index > 0:
		team_search = teams[index-1]["name"]
	else:
		team_search = ""
	add_all_players(true)


func _on_PositionSelect_item_selected(index):
	if index > 0:
		position_search = POSITIONS[index-1]
	else:
		position_search = ""
	add_all_players(true)


func _on_FootSelect_item_selected(index):
	if index > 0:
		foot_search = FOOTS[index-1]
	else:
		foot_search = ""
	add_all_players(true)


func _on_Next_pressed():
	current_page += 1
	if current_page > current_players.size()/10:
		current_page = current_players.size()/10
	add_all_players(false)


func _on_Prev_pressed():
	current_page -= 1
	if current_page < 0:
		current_page = 0
	add_all_players(false)


func _on_InfoSelect_item_selected(index):
	info_type = INFO_TYPES[index]
	add_all_players(false)


func _on_Close_pressed():
	hide()
