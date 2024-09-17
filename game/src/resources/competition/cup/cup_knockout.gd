# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CupKnockout
extends Competition

@export var knockout: Knockout

func _init(
	p_knockout: Knockout = Knockout.new(),
) -> void:
	super()
	knockout = p_knockout


func set_up(teams: Array[Team]) -> void:
	knockout.set_up(teams)


func get_matches() -> Array[Match]:
	var matches: Array[Match] = []
	
	# group a
	for i: int in knockout.teams_a.size() / 2:
		var matchz: Match = Match.new()
		# assign first vs last, first + 1 vs last - 1 etc...
		matchz.home = knockout.teams_a[i]
		matchz.away = knockout.teams_a[-i]
		matches.append(matchz)
	# group b
	for i: int in knockout.teams_b.size() / 2:
		var matchz: Match = Match.new()
		# assign first vs last, first + 1 vs last - 1 etc...
		matchz.home = knockout.teams_b[i]
		matchz.away = knockout.teams_b[-i]
		matches.append(matchz)
	
	return matches
