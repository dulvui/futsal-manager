# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change

@onready 
var animation_player:AnimationPlayer = $AnimationPlayer

var formations:Array = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]
var player_to_replace:int
var team:Dictionary

func _ready() -> void:
	for formation in formations:
		$FormationSelect.add_item(formation)
		
	$FormationSelect.selected = formations.find("2-2")

func set_up(active_team:Dictionary = Config.get_selected_team()) -> void:
	team = active_team
	_set_active_players()
	$PlayerList.set_up(true, team)
	animation_player.play("Fade" + team["formation"])

func _on_FormationSelect_item_selected(index:int) -> void:
	animation_player.play_backwards("Fade" + team["formation"] )
	await animation_player.animation_finished
	_set_active_players()
	team["formation"] = formations[index]
#	Config.save_all_data()
	animation_player.play("Fade" + team["formation"] )

func _set_active_players() -> void:
	$Field/G.set_player(team["players"]["active"][0])
	$Field/D.set_player(team["players"]["active"][1])
	$Field/WL.set_player(team["players"]["active"][2])
	$Field/WR.set_player(team["players"]["active"][3])
	$Field/P.set_player(team["players"]["active"][4])

func _on_D_change_player(_player) -> void:
	player_to_replace = 1
	$PlayerList.show()

func _on_WL_change_player(_player) -> void:
	player_to_replace = 2
	$PlayerList.show()

func _on_WR_change_player(_player) -> void:
	player_to_replace = 3
	$PlayerList.show()

func _on_P_change_player(_player) -> void:
	player_to_replace = 4
	$PlayerList.show()
	
func _on_G_change_player(_player) -> void:
	player_to_replace = 0
	$PlayerList.show()

func _on_PlayerList_select_player(_player) -> void:
	_change_player(_player)
	_set_active_players()
	$PlayerList.set_up_players(true, team)
	$PlayerList.hide()
	emit_signal("change")
	
func _change_player(player:Dictionary) -> void:
	team["players"]["subs"].append(team["players"]["active"][player_to_replace])
	team["players"]["active"][player_to_replace] = player
	for sub_index in team["players"]["subs"].size():
		if team["players"]["subs"][sub_index]["id"] == player["id"]:
			team["players"]["subs"].remove_at(sub_index)
			return
