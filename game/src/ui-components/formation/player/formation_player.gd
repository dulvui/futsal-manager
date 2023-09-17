# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal change_player

var player:Dictionary


func set_player(new_player:Dictionary) -> void:
	player = new_player
	$Name.text = player["surname"]
	$Nr.text = str(player["nr"])


func _on_Change_pressed() -> void:
	emit_signal("change_player",player)
