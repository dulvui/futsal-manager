# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Mentality {ULTRA_OFFENSIVE, OFFENSIVE, NORMAL, DEFENSIVE, ULTRA_DEFENSIVE}
enum Passing {LONG, SHORT, DIRECT, NORMAL}
enum Formations {TT=22,OTO=121,OOT=112,TOO=211,TO=31,OT=13}

var goalkeeper:Player

# trainer tactics settings
var tactics = {
	"formation" : Formations.TT,
	"mentality" : Mentality.NORMAL,
	"pressing" : false,
	"counter_attack" : false,
	"passing" : Passing.NORMAL,
}

# to calculate possession
var possession_counter = 0.0

var has_ball = false

var players:Array[Player]
# player that is attacking/defending
var active_player:Player

func set_up(team:Team) -> void: # TODO add tactics
	players = []
	var team_players = team.line_up.players
	goalkeeper = team.line_up.goalkeeper
#	goalkeeper.set_up(team.line_up.goalkeeper)
	
	players.append_array(team_players)

	active_player = players[-1]
	
func update_players() -> void:
#	for player in players:
#		player.update()
	pass

func change_active_player() -> void:
	var other_players = players.duplicate()
	other_players.remove_at(players.find(active_player))
	
	active_player = other_players[(randi() % other_players.size())]


