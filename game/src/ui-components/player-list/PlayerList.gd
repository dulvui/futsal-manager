extends Control

signal select_player

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

var name_search = ""
var team_search = ""
var position_search = ""
var foot_search = ""

var all_players = []
var current_players = []

const FISICAL_TITLES = ["acc","agi","jum","pac","sta","str"]
const GENERAL_TITLES = ["POS","PR."]

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
	
	var headers = ["surname"]
	for mental in Constants.MENTAL:
		headers.append(mental)
	$Table.set_up(all_players.duplicate(true), headers)
			
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
		
	for title in GENERAL_TITLES:
		var label = Label.new()
		label.text = title
		$Titles/Details.add_child(label)
	

func add_subs():
	pass
		
func add_match_players():
	pass
		
func add_all_players(filter):
	pass

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


func _on_Close_pressed():
	hide()
