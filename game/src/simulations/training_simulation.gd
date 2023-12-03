# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# will be emitted on injury with player and injury details as parameter
signal injury

# trains the players and increases therir stats depending on 
# training plan, players can also injure during training 
func train_players() -> void:
	pass


# dependfing on your team and traingin abilities
# and tactics, plan according trainings for month/week ??
# could be used if training gets delegated
func plan_trainings() -> void:
	pass
