# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change_player(player:Player)

@onready var name_label:Label = $VBoxContainer/Name
@onready var nr_label:Label = $VBoxContainer/Nr


var player:Player

func _ready() -> void:
	nr_label.text = str(player.nr)
	name_label.text = player.surname

func set_player(_player:Player) -> void:
	player = _player


func _on_Change_pressed() -> void:
	change_player.emit(player)
