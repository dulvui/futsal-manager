# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualMatchStats
extends MarginContainer

@onready var home_possession: Label = $VBoxContainer/HomePossession
@onready var away_possession: Label = $VBoxContainer/AwayPossession
@onready var home_shots: Label = $VBoxContainer/HomeShots
@onready var away_shots: Label = $VBoxContainer/AwayShots
@onready var home_shots_on_target: Label = $VBoxContainer/HomeShotsOnTarget
@onready var away_shots_on_target: Label = $VBoxContainer/AwayShotsOnTarget
@onready var home_fouls: Label = $VBoxContainer/HomeFouls
@onready var away_fouls: Label = $VBoxContainer/AwayFouls
@onready var home_free_kicks: Label = $VBoxContainer/HomeFreeKicks
@onready var away_free_kicks: Label = $VBoxContainer/AwayFreeKicks
@onready var home_penalties: Label = $VBoxContainer/HomePenalties
@onready var away_penalties: Label = $VBoxContainer/AwayPenalties
@onready var home_throw_in: Label = $VBoxContainer/HomeThrowIn
@onready var away_throw_in: Label = $VBoxContainer/AwayThrowIn
@onready var home_corners: Label = $VBoxContainer/HomeCorners
@onready var away_corners: Label = $VBoxContainer/AwayCorners
@onready var home_pass: Label = $VBoxContainer/HomePass
@onready var away_pass: Label = $VBoxContainer/AwayPass
@onready var home_pass_success: Label = $VBoxContainer/HomePassSuccess
@onready var away_pass_success: Label = $VBoxContainer/AwayPassSuccess
@onready var home_yellow_cards: Label = $VBoxContainer/HomeYellowCards
@onready var away_yellow_cards: Label = $VBoxContainer/AwayYellowCards
@onready var home_red_cards: Label = $VBoxContainer/HomeRedCards
@onready var away_red_cards: Label = $VBoxContainer/AwayRedCards


func update_stats(home_stats: MatchStatistics, away_stats: MatchStatistics) -> void:
	home_possession.text = "%d " % home_stats.possession + "%"
	away_possession.text = "%d " % away_stats.possession + "%"
	home_shots.text = "%d " % home_stats.passes
	away_shots.text = "%d " % away_stats.passes
	home_shots_on_target.text = "%d " % home_stats.passes_success
	away_shots_on_target.text = "%d " % away_stats.passes_success
	home_fouls.text = "%d " % home_stats.shots
	away_fouls.text = "%d " % away_stats.shots
	home_free_kicks.text = "%d " % away_stats.shots_on_target
	away_free_kicks.text = "%d " % home_stats.shots_on_target
	home_penalties.text = "%d " % home_stats.corners
	away_penalties.text = "%d " % away_stats.corners
	home_throw_in.text = "%d " % home_stats.kick_ins
	away_throw_in.text = "%d " % away_stats.kick_ins
	home_corners.text = "%d " % home_stats.fouls
	away_corners.text = "%d " % away_stats.fouls
	home_pass.text = "%d " % home_stats.free_kicks
	away_pass.text = "%d " % away_stats.free_kicks
	home_pass_success.text = "%d " % home_stats.penalties
	away_pass_success.text = "%d " % away_stats.penalties
	home_yellow_cards.text = "%d " % home_stats.yellow_cards
	away_yellow_cards.text = "%d " % away_stats.yellow_cards
	home_red_cards.text = "%d " % home_stats.red_cards
	away_red_cards.text = "%d " % away_stats.red_cards
