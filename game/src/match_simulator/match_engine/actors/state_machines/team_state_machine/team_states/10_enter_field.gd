# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TeamStateEnterField
extends StateMachineState


func update() -> void:
	# GAME STARTS

	# move players to positon
	# if reached
	change_to(TeamStateKickoff.new())

