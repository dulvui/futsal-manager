extends Control

signal select_player

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

var team_search = ""
var foot_search = ""

var all_players = []
var active_filters = {}

const FISICAL_TITLES = ["acc","agi","jum","pac","sta","str"]
const GENERAL_TITLES = ["POS","PR."]

const POSITIONS = ["G","D","WL","WR","P","U"]
const INFO_TYPES = ["GENERAL","FISICAL","MENTAL"]
const FOOTS = ["R","L","RL"]


func set_up(selected_team = false):
	for team in DataSaver.teams:
		if not selected_team or team["name"] == DataSaver.selected_team:
			for player in team["players"]["active"]:
				all_players.append(player)
			for player in team["players"]["subs"]:
				all_players.append(player)
	
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

		
func add_match_players():
	pass


func _on_NameSearch_text_changed(text):
	active_filters["surname"] = text
	_filter_table()


#func _on_TeamSelect_item_selected(index):
#	var teams = []
#	for team in DataSaver.teams:
#		if team["name"] != DataSaver.selected_team:
#			teams.append(team)
#
#	if index > 0:
#		team_search = teams[index-1]["name"]
#	else:
#		team_search = ""
#	add_all_players(true)


func _on_PositionSelect_item_selected(index):
	if index > 0:
		active_filters["position"] = POSITIONS[index-1]
	else:
		active_filters["position"] = ""
	_filter_table()
#
#func _on_FootSelect_item_selected(index):
#	if index > 0:
#		foot_search = FOOTS[index-1]
#	else:
#		foot_search = ""
#	add_all_players(true)

func _filter_table():
	$Table.filter(active_filters)

func _on_Close_pressed():
	hide()


func _on_Table_select_player(player):
	print("change in list")
	emit_signal("select_player",player)
