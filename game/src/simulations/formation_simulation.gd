# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# TODO check if final state machine would make more sense for this AIS


# makes the formation for the team to playe the next match
# might be only used for teams that play against you
# others just use best fisic players or so and get random stats anyway
func make_formation(_team: Dictionary) -> void:
	pass


# checks during match if changes should be made
# according to lines tactics and stamina
# can be used also for your formation in
# automated change mode
func check_changes(_players: Dictionary) -> void:
	pass


# to replace a single player in case of injury or manual
# changes, or red card and so tactitc changes etc.
func replace_player(_player: Dictionary, _players: Dictionary) -> void:
	pass
