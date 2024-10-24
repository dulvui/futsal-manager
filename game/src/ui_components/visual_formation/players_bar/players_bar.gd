# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayersBar
extends HBoxContainer


signal change_request(team: Team, p1: Player, p2: Player)

const FormationPlayer: PackedScene = preload("res://src/ui_components/visual_formation/player/formation_player.tscn")

var change_players: Array[Player]
var team: Team

@onready var players: HBoxContainer = $Players
@onready var bench: HBoxContainer = $Bench


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	change_players = []


func set_up(p_team: Team = Global.team) -> void:
	team = p_team

	# field players
	for player: Player in team.get_starting_players():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		# setup
		formation_player.set_player(player)
		formation_player.select.connect(_on_formation_player_select.bind(player))
		players.add_child(formation_player)
	
	# bench
	for player: Player in team.get_sub_players():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		# setup
		formation_player.set_player(player)
		formation_player.select.connect(_on_formation_player_select.bind(player))
		bench.add_child(formation_player)


func _on_formation_player_select(player: Player) -> void:
	if player not in change_players:
		change_players.append(player)
		if change_players.size() == 2:
			change_request.emit(team, change_players[0], change_players[1])
			change_players.clear()
	else:
		change_players.erase(player)

