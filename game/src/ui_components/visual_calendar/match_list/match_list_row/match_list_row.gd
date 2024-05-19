# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name MatchListRow

@onready var home: Label = $HBoxContainer/Home
@onready var away: Label = $HBoxContainer/Away
@onready var result: Label = $HBoxContainer/Result

func set_up(matchz:Match) -> void:
	home.text = matchz.home.name
	away.text = matchz.away.name
	
	if matchz.over:
		result.text = matchz.get_result()
