# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var home_team:Team
var away_team:Team

func set_up(p_home_team:Team, p_away_team:Team) -> void:
	home_team = p_home_team
	away_team = p_away_team


func update() -> void:
	pass
