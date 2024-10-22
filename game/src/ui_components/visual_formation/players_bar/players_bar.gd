# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayersBar
extends HBoxContainer


const FormationPlayer: PackedScene = preload("res://src/ui_components/visual_formation/player/formation_player.tscn")

@onready var players: HBoxContainer = $Players
@onready var bench: HBoxContainer = $Bench


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func set_up(team: Team = Global.team) -> void:

	# field players
	for player: Player in team.get_field_players():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		# setup
		formation_player.set_player(player)
		players.add_child(formation_player)
	
	# bench
	for player: Player in team.get_sub_players():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		# setup
		formation_player.set_player(player)
		bench.add_child(formation_player)
		print("bench")

