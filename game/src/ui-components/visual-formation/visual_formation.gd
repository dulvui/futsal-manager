# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change

const FormationPlayer:PackedScene = preload("res://src/ui-components/visual-formation/player/formation_player.tscn")

@onready var player_list:Control = $PlayerList
@onready var formation_select:OptionButton = $VBoxContainer/FormationSelect
@onready var players:VBoxContainer = $VBoxContainer/Field/Players
@onready var goalkeeper:HBoxContainer = $VBoxContainer/Field/Players/Goalkeeper
@onready var defense:HBoxContainer = $VBoxContainer/Field/Players/Defense
@onready var center:HBoxContainer = $VBoxContainer/Field/Players/Center
@onready var attack:HBoxContainer = $VBoxContainer/Field/Players/Attack


var player_to_replace:int
var team:Team

func set_up(active_team:Team = Config.team) -> void:
	team = active_team
	player_list.set_up(true, team)
	
	# set up fomation options
	for formation:String in Formation.Variations:
		formation_select.add_item(formation)
	formation_select.selected = team.line_up.formation.variation
	
	_set_players()

func _on_FormationSelect_item_selected(index:int) -> void:
	_set_players()
	team.line_up.formation = Formation.new(formation_select.selected)

func _set_players() -> void:
	# clean field
	for players:HBoxContainer in players.get_children():
		for player:Control in players.get_children():
			player.queue_free()
			
	# add golakeeper
	if team.line_up.formation.goalkeeper > 0:
		var formation_goal_keeper:Control = FormationPlayer.instantiate()
		formation_goal_keeper.set_player(team.line_up.goalkeeper)
		goalkeeper.add_child(formation_goal_keeper)
	
	# add defenders
	for i:int in team.line_up.formation.defense:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.line_up.players[i])
		defense.add_child(formation_player)
		
	# add center
	var d:int = team.line_up.formation.defense
	for i:int in team.line_up.formation.center:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.line_up.players[i + d])
		center.add_child(formation_player)
		
	# add attack
	var c:int = team.line_up.formation.center
	for i:int in team.line_up.formation.attack:
		var formation_player:Control = FormationPlayer.instantiate()
		formation_player.set_player(team.line_up.players[i + c])
		attack.add_child(formation_player)


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
		
