# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CupKnockout
extends Competition

@export var knockout: Knockout
# includes also historical winners
# winners[-1] is latest winner
@export var winners: Array[Team]


func _init(
	p_knockout: Knockout = Knockout.new(),
	p_winners: Array[Team] = [],
) -> void:
	super()
	knockout = p_knockout
	winners = p_winners


func set_up(teams: Array[Team]) -> void:
	knockout.set_up(teams)


func get_cup_matches() -> Array[Match]:
	var matches: Array[Match] = []

	# group a
	for i: int in knockout.teams_a.size() / 2:
		# assign first vs last, first + 1 vs last - 1 etc...
		var matchz: Match = Match.new(knockout.teams_a[i], knockout.teams_a[-(i + 1)], id, name)
		matches.append(matchz)
	# group b
	for i: int in knockout.teams_b.size() / 2:
		# assign first vs last, first + 1 vs last - 1 etc...
		var matchz: Match = Match.new(knockout.teams_b[i], knockout.teams_b[-(i + 1)], id, name)
		matches.append(matchz)

	return matches
