# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change

@onready 
var animation_player:AnimationPlayer = $AnimationPlayer

@onready
var player_list:Control = $PlayerList

var formations:Array[String] = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]
var player_to_replace:int
var team:Team

func _ready() -> void:
	for formation:String in formations:
		$FormationSelect.add_item(formation)
		
	$FormationSelect.selected = formations.find("2-2")

func set_up(active_team:Team = Config.team) -> void:
	team = active_team
	_set_active_players()
	player_list.set_up(true, team)
	# TODO play animation
#	animation_player.play("Fade" + team["formation"])

func _on_FormationSelect_item_selected(index:int) -> void:
#	animation_player.play_backwards("Fade" + team.line_up.formation )
	await animation_player.animation_finished
	_set_active_players()
	team["formation"] = formations[index]
#	Config.save_all_data()
#	animation_player.play("Fade" + team["formation"] )

func _set_active_players() -> void:
	$Field/G.set_player(team.line_up.goalkeeper)
	$Field/D.set_player(team.line_up.players[0])
	$Field/WL.set_player(team.line_up.players[1])
	$Field/WR.set_player(team.line_up.players[2])
	$Field/P.set_player(team.line_up.players[3])
	pass

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
	_set_active_players()
	player_list.hide()
	emit_signal("change")
	
func _change_player(player:Player) -> void:
	if player_to_replace >= 0:
		team.line_up.players[player_to_replace] = player
	else:
		team.line_up.goalkeeper = player
		
