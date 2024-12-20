# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerStateEnterField
extends StateMachineState


func execute() -> void:
	# move to center
	(owner as PlayerStateMachine).player.set_destination(owner.field.center)

	# start positon is reached
	# change_to(PlayerStateStartPosition.new())
