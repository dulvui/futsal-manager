# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name TeamProfile

@onready var name_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/Name
@onready var player_list:PlayerList = $VBoxContainer/HBoxContainer/PlayerList

func set_team(team:Team) -> void:
	name_label.text = team.name
	player_list.set_up(false, true, team, false)
