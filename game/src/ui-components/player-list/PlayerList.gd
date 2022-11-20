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
const INFO_TYPES = ["mental","physical","technical","goalkeeper"]
const FOOTS = ["R","L","RL"]


func set_up(use_selected_team, include_active_players):
	
	set_up_players(use_selected_team, include_active_players)

			
	$LegaueSelect.add_item("ITALIA")
	
	$TeamSelect.add_item("NO_TEAM")
	for team in DataSaver.get_teams():
		if team["name"] != DataSaver.team_name:
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
		
	for info_type in INFO_TYPES:
		$InfoSelect.add_item(info_type)


func set_up_players(use_selected_team, include_active_players):
	all_players = []
	for team in DataSaver.get_teams():
		if not use_selected_team or team["name"] == DataSaver.team_name:
			if include_active_players:
				for player in team["players"]["active"]:
					all_players.append(player)
			for player in team["players"]["subs"]:
				all_players.append(player)
	
	var headers = ["surname"]
	for attribute in Constants.ATTRIBUTES[INFO_TYPES[0]]:
		headers.append(attribute)
		
	$Table.set_up(headers, all_players.duplicate(true))
	
func remove_player(player_id):
	active_filters["id"] = player_id
	_filter_table(true)

func _on_NameSearch_text_changed(text):
	active_filters["surname"] = text
	_filter_table()


func _on_TeamSelect_item_selected(index):
	if index > 0:
		active_filters["team"] = $TeamSelect.get_item_text(index)
	else:
		active_filters["team"] = ""
	_filter_table()
	


func _on_PositionSelect_item_selected(index):
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

	$Table.set_up(headers)
	_filter_table()
#
#func _on_FootSelect_item_selected(index):
#	if index > 0:
#		foot_search = FOOTS[index-1]
#	else:
#		foot_search = ""
#	add_all_players(true)

func _filter_table(exclusive = false):
	$Table.filter(active_filters, exclusive)

func _on_Close_pressed():
	hide()


func _on_Table_select_player(player):
	print("change in list")
	emit_signal("select_player",player)


func _on_InfoSelect_item_selected(index):
	var headers = ["surname"]
	for attribute in Constants.ATTRIBUTES[INFO_TYPES[index]]:
		headers.append(attribute)
	$Table.set_up(headers)
