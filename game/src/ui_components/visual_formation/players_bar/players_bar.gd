# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayersBar
extends HBoxContainer


signal change_request(team: Team, p1: Player, p2: Player)

const FormationPlayer: PackedScene = preload("res://src/ui_components/visual_formation/player/formation_player.tscn")

var change_players: Array[Player]
var team: Team

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
		# set unique node name to player id, so it can be accessed easily
		formation_player.name = str(player.id)
		formation_player.unique_name_in_owner = true
		add_child(formation_player)
	
	add_child(VSeparator.new())

	# bench
	for player: Player in team.get_sub_players():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		# setup
		formation_player.set_player(player)
		formation_player.select.connect(_on_formation_player_select.bind(player))
		# set unique node name to player id, so it can be accessed easily
		formation_player.name = str(player.id)
		formation_player.unique_name_in_owner = true
		add_child(formation_player)


func _on_formation_player_select(player: Player) -> void:
	if player not in change_players:
		change_players.append(player)
		if change_players.size() == 2:
			change_request.emit(team, change_players[0], change_players[1])
			
			# access player easily with player id set as node name in setup
			var player0: VisualFormationPlayer = get_node(str(change_players[0].id))
			var player1: VisualFormationPlayer = get_node(str(change_players[1].id))
			var index0: int = player0.get_index()
			var index1: int = player1.get_index()
			move_child(player0, index1)
			move_child(player1, index0)

			change_players.clear()
	else:
		change_players.erase(player)

