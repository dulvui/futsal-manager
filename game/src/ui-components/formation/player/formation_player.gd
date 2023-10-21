# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change_player(player:Player)

var player:Player

func set_player(new_player:Player) -> void:
	player = new_player
	$Name.text = player.surname
	$Nr.text = str(player.nr)

func _on_Change_pressed() -> void:
	change_player.emit(player)
