# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change

const FormationPlayer:PackedScene = preload("res://src/ui-components/visual-formation/player/formation_player.tscn")

@onready var player_list:Control = $HBoxContainer/PlayerList
@onready var players:VBoxContainer = $HBoxContainer/LineUp/Field/Players
@onready var subs:VBoxContainer = $HBoxContainer/Subs/List

@onready var formation_select:OptionButton = $HBoxContainer/LineUp/HBoxContainer/FormationSelect

@onready var goalkeeper:HBoxContainer = $HBoxContainer/LineUp/Field/Players/Goalkeeper
@onready var defense:HBoxContainer = $HBoxContainer/LineUp/Field/Players/Defense
@onready var center:HBoxContainer = $HBoxContainer/LineUp/Field/Players/Center
@onready var attack:HBoxContainer = $HBoxContainer/LineUp/Field/Players/Attack


var lineup_players:Array[int] = []
var list_player:Player = null

var team:Team

func set_up(active_team:Team = Config.team) -> void:
	team = active_team
	player_list.set_up(true, false, team)
	
	# set up fomation options
	for formation:String in Formation.Variations:
		formation_select.add_item(formation)
	formation_select.selected = team.formation.variation
	
	_set_players()

func _set_players() -> void:
	# clean field
	for players:HBoxContainer in players.get_children():
		for player:Control in players.get_children():
			player.queue_free()
			
	# clean subs
	for sub:Control in subs.get_children():
		sub.queue_free()
	
	var pos_count:int = 0
	# add golakeeper
	if team.formation.goalkeeper > 0:
		var formation_goal_keeper:Control = FormationPlayer.instantiate()
		formation_goal_keeper.set_player(team.get_goalkeeper(), team)
		formation_goal_keeper.change_player.connect(_on_line_up_select_player.bind(pos_count))
		goalkeeper.add_child(formation_goal_keeper)
		pos_count += 1
	
	# add defenders
	for i:int in team.formation.defense:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(_on_line_up_select_player.bind(pos_count))
		defense.add_child(formation_player)
		pos_count += 1
		
	# add center
	for i:int in team.formation.center:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(_on_line_up_select_player.bind(pos_count))
		center.add_child(formation_player)
		pos_count += 1
		
	# add attack
	for i:int in team.formation.attack:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(_on_line_up_select_player.bind(pos_count))
		attack.add_child(formation_player)
		pos_count += 1
		
	# add subs
	for i:int in team.get_sub_players().size():
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(_on_line_up_select_player.bind(pos_count))
		subs.add_child(formation_player)
		pos_count += 1

func _on_prev_formation_pressed() -> void:
	if formation_select.selected > 0:
		formation_select.selected -= 1
	else:
		formation_select.selected = formation_select.item_count - 1
	_update_formation()

func _on_next_formation_pressed() -> void:
	if formation_select.selected < formation_select.item_count - 1:
		formation_select.selected += 1
	else:
		formation_select.selected = 0
	_update_formation()

func _on_formation_select_item_selected(index: int) -> void:
	_update_formation()

func _update_formation() -> void:
	team.formation = Formation.new(formation_select.selected)
	_set_players()

func _on_line_up_select_player(index:int) -> void:
	lineup_players.append(index)
	if list_player or lineup_players.size() == 2:
		_change_player()
	
func _on_player_list_select_player(player: Player) -> void:
	list_player = player
	if lineup_players.size() > 0:
		_change_player()
	
func _change_player() -> void:
	# switch betwenn list and lineup
	if lineup_players.size() == 1:
		team.lineup_player_ids[lineup_players[0]] = list_player.id
	# switch betwenn lineup and lineup
	elif lineup_players.size() == 2:
		var temp_id:int = team.lineup_player_ids[lineup_players[0]]
		team.lineup_player_ids[lineup_players[0]] = team.lineup_player_ids[lineup_players[1]]
		team.lineup_player_ids[lineup_players[1]] = temp_id
	else:
		print("error in substitution")
		return
		
	_set_players()
	player_list.set_up(true, false, team)
	change.emit()
	
	lineup_players.clear()
	list_player = null

