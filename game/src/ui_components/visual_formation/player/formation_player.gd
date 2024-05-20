# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualFormationPlayer
extends Control

signal change_player

@onready var name_label: Label = $VBoxContainer/Name
@onready var nr_label: Label = $VBoxContainer/Nr
@onready var state_color:ColorRect = $ColorRect

var color:Color


var player: Player

func _ready() -> void:
	nr_label.text = str(player.nr)
	name_label.text = player.surname
	state_color.color = color

func set_player(_player: Player, team: Team=null) -> void:
	player = _player
	
	if team:
		if team.is_lineup_player(player):
			color = Color.PALE_GREEN
		elif team.is_sub_player(player):
			color = Color.SKY_BLUE
		else:
			color = Color.DARK_RED

func _on_Change_pressed() -> void:
	change_player.emit()
