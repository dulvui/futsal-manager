# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# if player is injured, he cant participate on trainings
# if a player is injured for a long time or evene an enitre season,
# on season development, the player just increases/decreses a bit

# injuries can occur during trainings and matches
# big injuries more likely in matches

# ohter teams players just get upgarde/downgrade periodically
# depending on team training stats and grothw_potential
# so bad teams in low divisions make also bad training
# good teams make good training


func make_season_development() -> void:
	pass


func make_training() -> void:
	pass


func check_injuries() -> void:
	pass
