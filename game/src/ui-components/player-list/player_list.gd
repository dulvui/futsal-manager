# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal select_player

const PlayerProfile:PackedScene = preload("res://src/ui-components/player-profile/player_profile.tscn")

var team_search:String = ""
var foot_search:String = ""

var active_filters:Dictionary = {}

const FISICAL_TITLES:Array = ["acc","agi","jum","pac","sta","str"]

const POSITIONS:Array = ["G","D","WL","WR","P","U"]
const INFO_TYPES:Array = ["mental","physical","technical","goalkeeper"]
const FOOTS:Array = ["R","L","RL"]

@onready var table:Control = $VBoxContainer/Table

# select filters
@onready var info_select:OptionButton = $VBoxContainer/HBoxContainer/InfoSelect
@onready var team_select:OptionButton = $VBoxContainer/HBoxContainer/TeamSelect
@onready var league_select:OptionButton = $VBoxContainer/HBoxContainer/LeagueSelect
@onready var pos_select:OptionButton = $VBoxContainer/HBoxContainer/PositionSelect


func set_up(include_lineup:bool, active_team:Team = null) -> void:
	
	set_up_players(include_lineup, active_team)
	league_select.add_item("ITALIA")
	
	team_select.add_item("NO_TEAM")
	for team in Config.league.teams:
		if team ==null or team.name != Config.team.name:
			team_select.add_item(team.name)
			
	pos_select.add_item("NO_POS")
	for pos:String in POSITIONS:
		pos_select.add_item(pos)
		
	for info_type:String in INFO_TYPES:
		info_select.add_item(info_type)


func set_up_players(include_lineup:bool, active_team:Team = null) -> void:
	_reset_options()
	
	var all_players:Array[Player] = []
	if active_team == null:
		for team in Config.league.teams:
			for player in team.players:
				all_players.append(player)
	else:
		if include_lineup:
			for player in active_team.line_up.players:
				all_players.append(player)
		for player in active_team.players:
			all_players.append(player)
	
	var headers:Array[String] = ["position", "surname"]
	for attribute:String in Constants.ATTRIBUTES[INFO_TYPES[0]]:
		headers.append(attribute)
	table.set_up(headers,INFO_TYPES[0], all_players)
	
func remove_player(player_id:int) -> void:
	active_filters["id"] = player_id
	_filter_table(true)

func _on_NameSearch_text_changed(text:String) -> void:
	active_filters["surname"] = text
	_filter_table()


func _on_TeamSelect_item_selected(index:int) -> void:
	if index > 0:
		active_filters["team"] = team_select.get_item_text(index)
	else:
		active_filters["team"] = ""
	_filter_table()
	


func _on_PositionSelect_item_selected(index:int) -> void:
	if index > 0:
		active_filters["position"] = POSITIONS[index-1]
	else:
		active_filters["position"] = ""
	
	var headers:Array[String] = ["position", "surname"]
	if active_filters["position"] == "G":
		for attribute:int in Constants.ATTRIBUTES["goalkeeper"]:
			headers.append(attribute)
		info_select.select(INFO_TYPES.size() - 1)
	else:
		for attribute:int in Constants.ATTRIBUTES[INFO_TYPES[0]]:
			headers.append(attribute)
		info_select.select(0)

	table.set_up(headers, INFO_TYPES[index])
	_filter_table()
#
#func _on_FootSelect_item_selected(index):
#	if index > 0:
#		foot_search = FOOTS[index-1]
#	else:
#		foot_search = ""
#	add_all_players(true)

func _filter_table(exclusive:bool = false) -> void:
	table.filter(active_filters, exclusive)

func _on_Close_pressed() -> void:
	hide()


func _on_InfoSelect_item_selected(index:int) -> void:
	var headers:Array[String] = ["position", "surname"]
	for attribute:String in Constants.ATTRIBUTES[INFO_TYPES[index]]:
		headers.append(attribute)
	table.update(headers, INFO_TYPES[index])
	

func _reset_options() -> void:
	league_select.selected = 0
	pos_select.selected = 0
	team_select.selected = 0
	info_select.selected = 0


func _on_table_info_player(player:Player) -> void:
	var player_profile:Control = PlayerProfile.instantiate()
	add_child(player_profile)
	player_profile.set_global_position(Vector2.ZERO)
	player_profile.set_up_info(player)
	

func _on_table_select_player(player:Player) -> void:
	print("change in list")
	emit_signal("select_player",player)
