# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MatchInfo
extends HBoxContainer

@onready var home: Label = $Home
@onready var away: Label = $Away
@onready var result: Label = $Result


func setup(matchz: Match) -> void:
	home.text = matchz.home.name
	away.text = matchz.away.name

	if matchz.over:
		result.text = matchz.get_result()

		# make winner label bold
		ThemeUtil.bold(home, matchz.home_goals >= matchz.away_goals)
		ThemeUtil.bold(away, matchz.home_goals <= matchz.away_goals)
