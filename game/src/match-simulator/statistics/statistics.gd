# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node





func increase_pass(success) -> void:
	statistics.passes += 1
	if success:
		statistics.passes_success += 1
		
func increase_shots(on_target) -> void:
	statistics.shots += 1
	if on_target:
		statistics.shots_on_target += 1
		
func increase_headers(on_target) -> void:
	statistics.headers += 1
	if on_target:
		statistics.headers_on_target += 1
		
func increase_goals() -> void:
	statistics.goals += 1
	
func increase_corners() -> void:
	statistics.corners += 1
	
func increase_kick_ins() -> void:
	statistics.kick_ins += 1
	
func increase_fouls() -> void:
	statistics.fouls += 1
	
func increase_free_kicks() -> void:
	statistics.free_kicks += 1

func increase_penalties() -> void:
	statistics.penalties += 1

func increase_red_cards() -> void:
	statistics.red_cards += 1
	
func increase_yellow_cards() -> void:
	statistics.yellow_cards += 1
