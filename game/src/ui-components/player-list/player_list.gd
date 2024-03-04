# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name PlayerList

signal select_player(player:Player)

const info_types:Array = ["all", "mental","physical","technical","goalkeeper"]

@onready var table:PlayerTable = $VBoxContainer/Table
@onready var player_profile:Control = $PlayerProfile
# select filters
@onready var info_select:OptionButton = $VBoxContainer/HBoxContainer/InfoSelect
@onready var team_select:OptionButton = $VBoxContainer/HBoxContainer/TeamSelect
@onready var league_select:OptionButton = $VBoxContainer/HBoxContainer/LeagueSelect
@onready var pos_select:OptionButton = $VBoxContainer/HBoxContainer/PositionSelect

var active_filters:Dictionary = {}
var active_info_type:int = 0
var team_search:String = ""

var all_players:Array[Player] = []

var show_profile:bool
var lineup_colors:bool
var active_team:Team

func set_up(only_lineup:bool,p_show_profile:bool, p_active_team:Team = null, p_lineup_colors:bool=true) -> void:
	show_profile = p_show_profile
	lineup_colors = p_lineup_colors
	active_team = p_active_team
	
	set_up_players(only_lineup, active_team)
	
	if not active_team:
		team_select.add_item("NO_TEAM")
		for league:League in Config.leagues.list:
			for team:Team in league.teams:
				if team ==null or team.name != Config.team.name:
					team_select.add_item(team.name)
	else:
		team_select.hide()
	
	pos_select.add_item("NO_POS")
	for pos:String in Player.Position.keys():
		pos_select.add_item(pos)
	
	if active_team == null:
		league_select.add_item("ALL_LEAGUES")
		for league:League in Config.leagues.list:
			league_select.add_item(league.name)
	else:
		league_select.hide()
	
	for info_type:String in info_types:
		info_select.add_item(info_type)


func set_up_players(only_lineup:bool, p_active_team:Team = null, p_reset_options:bool=true) -> void:
	if p_reset_options:
		_reset_options()
	
	all_players = []
	if p_active_team == null:
		for league:League in Config.leagues.list:
			for team in league.teams:
				for player in team.players:
					all_players.append(player)
	else:
		active_team = p_active_team
		if only_lineup:
			all_players.append_array(active_team.get_lineup_players())
			all_players.append_array(active_team.get_sub_players())
		else:
			all_players.append_array(active_team.players)
			#all_players.append_array(active_team.get_lineup_players())
			#all_players.append_array(active_team.get_sub_players())
			#all_players.append_array(active_team.get_non_lineup_players())
	
	var headers:Array[String] = ["position", "surname"]
	for attribute:String in Constants.ATTRIBUTES[info_types[active_info_type]]:
		headers.append(attribute)
	table.set_up(headers,info_types[active_info_type], all_players, active_team, lineup_colors)
	
	# filter after setup causes grafical glitch 
	#_filter_table()

func remove_player(player_id:int) -> void:
	active_filters["id"] = player_id
	_filter_table(true)

func _on_NameSearch_text_changed(text:String) -> void:
	if text.length() > 2:
		active_filters["surname"] = text
		_filter_table()
	elif "surname" in active_filters and active_filters["surname"].length() > 0:
		active_filters["surname"] = ""
		_filter_table()

func _on_TeamSelect_item_selected(index:int) -> void:
	if index > 0:
		active_filters["team"] = team_select.get_item_text(index)
	else:
		active_filters["team"] = ""
	_filter_table()



func _on_league_select_item_selected(index:int) -> void:
	if index > 0:
		active_filters["league"] = league_select.get_item_text(index)
	else:
		active_filters["league"] = ""
		
	# clean team selector
	team_select.clear()
	team_select.add_item("NO_TEAM")
	
	# adjust team picker accoring to selected league
	for league:League in Config.leagues.list:
		if active_filters["league"] == "" or active_filters["league"] == league.name:
			for team:Team in league.teams:
				if team ==null or team.name != Config.team.name:
					team_select.add_item(team.name)
		
	_filter_table()


func _on_PositionSelect_item_selected(index:int) -> void:
	if index > 0:
		active_filters["position"] = Player.Position.values()[index-1]
	else:
		active_filters["position"] = ""
	
	var headers:Array[String] = ["position", "surname"]
	for attribute:String in Constants.ATTRIBUTES[info_types[active_info_type]]:
		headers.append(attribute)
	info_select.select(0)

	table.set_up(headers, info_types[active_info_type], all_players, active_team, lineup_colors)
	_filter_table()


func _filter_table(exclusive:bool = false) -> void:
	table.filter(active_filters, exclusive)

func _on_Close_pressed() -> void:
	hide()


func _on_InfoSelect_item_selected(index:int) -> void:
	var headers:Array[String] = ["position", "surname"]
	for attribute:String in Constants.ATTRIBUTES[info_types[index]]:
		headers.append(attribute)
	active_info_type = index
	table.update(headers, info_types[active_info_type])
	

func _reset_options() -> void:
	league_select.selected = 0
	pos_select.selected = 0
	team_select.selected = 0
	info_select.selected = 0
	active_info_type = 0


func _on_table_info_player(player:Player) -> void:
	if show_profile:
		player_profile.show()
		player_profile.set_up_info(player)
	else:
		select_player.emit(player)


func _on_player_profile_select(player: Player) -> void:
	select_player.emit(player)
