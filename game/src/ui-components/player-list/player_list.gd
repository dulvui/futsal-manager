# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal select_player

const PlayerProfile:PackedScene = preload("res://src/ui-components/player-profile/player_profile.tscn")

var team_search:String = ""
var foot_search:String = ""

var all_players:Array = []
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


func set_up(include_active_players:bool, active_team:Team = null) -> void:
	
	set_up_players(include_active_players, active_team)

			
	league_select.add_item("ITALIA")
	
	team_select.add_item("NO_TEAM")
	for team in Config.league.teams:
		if team ==null or team.name != Config.team.name:
			team_select.add_item(team.name)
			
	pos_select.add_item("NO_POS")
	for pos in POSITIONS:
		pos_select.add_item(pos)
		
	for info_type in INFO_TYPES:
		info_select.add_item(info_type)


func set_up_players(include_active_players:bool, active_team:Team = null) -> void:
	_reset_options()
	
	all_players = []
	if active_team == null:
		for team in Config.league.teams:
			for player in team.players:
				all_players.append(player)
	else:
		if include_active_players:
			for player in active_team.line_up.players:
				all_players.append(player)
		for player in active_team.players:
			all_players.append(player)
	
	var headers:Array = ["surname"]
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
		active_filters["team"] = team_select.get_item_text(index)
	else:
		active_filters["team"] = ""
	_filter_table()
	


func _on_PositionSelect_item_selected(index:int) -> void:
	if index > 0:
		active_filters["position"] = POSITIONS[index-1]
	else:
		active_filters["position"] = ""
	
	var headers:Array = ["surname"]
	if active_filters["position"] == "G":
		for attribute in Constants.ATTRIBUTES["goalkeeper"]:
			headers.append(attribute)
		info_select.select(INFO_TYPES.size() - 1)
	else:
		for attribute in Constants.ATTRIBUTES[INFO_TYPES[0]]:
			headers.append(attribute)
		info_select.select(0)

	table.set_up(headers)
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

func _on_Close_pressed():
	hide()


func _on_Table_select_player(player:Dictionary) -> void:
	print("change in list")
	emit_signal("select_player",player)


func _on_InfoSelect_item_selected(index:int) -> void:
	var headers = ["surname"]
	for attribute in Constants.ATTRIBUTES[INFO_TYPES[index]]:
		headers.append(attribute)
	table.set_up(headers)
	

func _reset_options() -> void:
	league_select.selected = 0
	pos_select.selected = 0
	team_select.selected = 0
	info_select.selected = 0


func _on_table_info_player(player:Dictionary):
	var player_profile:Control = PlayerProfile.instantiate()
	add_child(player_profile)
	player_profile.set_up_info(player)
