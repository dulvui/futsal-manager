# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change

const FormationPlayer:PackedScene = preload("res://src/ui-components/formation/player/formation_player.tscn")

@onready var player_list:Control = $PlayerList
@onready var formation_select:OptionButton = $VBoxContainer/FormationSelect
@onready var players:GridContainer = $VBoxContainer/Field/Players

var formations:Array[String] = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]
var player_to_replace:int
var team:Team

func _ready() -> void:
	for formation:String in formations:
		formation_select.add_item(formation)
	formation_select.selected = formations.find("2-2")

func set_up(active_team:Team = Config.team) -> void:
	team = active_team
	player_list.set_up(true, team)
	_set_players()

func _on_FormationSelect_item_selected(index:int) -> void:
	_set_players()
	team["formation"] = formations[index]

func _set_players() -> void:
	# clean field
	for player:Control in players.get_children():
		player.queue_free()
	# add players
	var formation_goal_keeper:Control = FormationPlayer.instantiate()
	formation_goal_keeper.set_player(team.line_up.goalkeeper)
	players.add_child(formation_goal_keeper)
	
	for player:Player in team.line_up.players:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(player)
		players.add_child(formation_player)

func _on_D_change_player(_player:Player) -> void:
	player_to_replace = 0
	player_list.show()

func _on_WL_change_player(_player:Player) -> void:
	player_to_replace = 1
	player_list.show()

func _on_WR_change_player(_player:Player) -> void:
	player_to_replace = 2
	player_list.show()

func _on_P_change_player(_player:Player) -> void:
	player_to_replace = 3
	player_list.show()
	
func _on_G_change_player(_player:Player) -> void:
	player_to_replace = -1
	player_list.show()

func _on_PlayerList_select_player(_player:Player) -> void:
	_change_player(_player)
	_set_players()
	player_list.hide()
	emit_signal("change")
	
func _change_player(player:Player) -> void:
	if player_to_replace >= 0:
		team.line_up.players[player_to_replace] = player
	else:
		team.line_up.goalkeeper = player
		
