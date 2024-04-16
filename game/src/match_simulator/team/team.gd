# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var goalkeeper:Player
var players:Array[Player]
# player that is attacking/defending
var active_player:Player
var has_ball:bool = false

func set_up(team:Team) -> void:
	players = []
	goalkeeper = team.get_goalkeeper()
	players.append_array(team.get_lineup_players())
	active_player = players[-1]
	
func change_active_player() -> Player:
	var other_players:Array[Player] = players.duplicate()
	other_players.remove_at(players.find(active_player))
	active_player = other_players[(randi() % other_players.size())]
	return active_player


