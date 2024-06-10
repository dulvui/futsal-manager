# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

class_name VisualTeam
extends Node2D

@onready var goalkeeper: VisualGoalkeeper = $VisualGoalkeeper
@onready var player1: VisualPlayer = $VisualPlayer1
@onready var player2: VisualPlayer = $VisualPlayer2
@onready var player3: VisualPlayer = $VisualPlayer3
@onready var player4: VisualPlayer = $VisualPlayer4


func set_up(
	sim_team: SimTeam, visual_ball: VisualBall, team_color: Color, update_interval: float
) -> void:
	goalkeeper.set_up(sim_team.goalkeeper, visual_ball, team_color, update_interval)
	player1.set_up(sim_team.players[0], visual_ball, team_color, update_interval)
	player2.set_up(sim_team.players[1], visual_ball, team_color, update_interval)
	player3.set_up(sim_team.players[2], visual_ball, team_color, update_interval)
	player4.set_up(sim_team.players[3], visual_ball, team_color, update_interval)


func update(update_interval: float) -> void:
	goalkeeper.update(update_interval)
	player1.update(update_interval)
	player2.update(update_interval)
	player3.update(update_interval)
	player4.update(update_interval)
