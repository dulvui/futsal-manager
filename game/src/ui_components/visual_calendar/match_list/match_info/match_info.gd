# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MatchInfo
extends HBoxContainer

@onready var home: Label = $Home
@onready var away: Label = $Away
@onready var result: Label = $Result


func set_up(matchz: Match) -> void:
	home.text = matchz.home.name
	away.text = matchz.away.name

	if matchz.over:
		result.text = matchz.get_result()
