# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name PlayerProgress

const NOISE = 2

static func update_players() -> void:
	for league in Config.leagues:
		for team in league.teams:
			for player in team.players:
				_season_progress(player)
				

static func _season_progress(player:Player) -> void:
	# add random noise
	var prestige_factor:int = player.prestige + randi_range(-NOISE, NOISE)
	# age factor only affects fisical attributes neagtively
	var age_factor:int = Config.date.year - player.birth_date.year + randi_range(-NOISE, NOISE)
	
	# check bounds prestige_factor
	if prestige_factor < 1:
		prestige_factor = 1
	if prestige_factor > 20:
		prestige_factor = 20
	
	# attributes progress
	player.attributes.mental
	
	player.attributes.physical
	
	player.attributes.technical
	
	player.attributes.goalkeeper
