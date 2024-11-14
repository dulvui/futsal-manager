# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Knockout
extends JSONResource

# single or two-legged matches
enum Legs {
	SINGLE,
	DOUBLE,
}

# side a and side b of knockout graph
# final is last remaining of teams_a vs teams_b
@export var teams_a: Array[Team]
@export var teams_b: Array[Team]
# defines if the play once or twice against each other
@export var legs_semi_finals: Legs
@export var legs_final: Legs
# saves all matches in every round, for easier visualization
@export var semi_finals_a: Array[Match]
@export var semi_finals_b: Array[Match]
@export var final: Match


func _init(
	p_teams_a: Array[Team] = [],
	p_teams_b: Array[Team] = [],
	p_legs_semi_finals: Legs = Legs.DOUBLE,
	p_legs_final: Legs = Legs.SINGLE,
	p_semi_finals_a: Array[Match] = [],
	p_semi_finals_b: Array[Match] = [],
	p_final: Match = Match.new(),
) -> void:
	teams_a = p_teams_a
	teams_b = p_teams_b
	legs_semi_finals = p_legs_semi_finals
	legs_final = p_legs_final
	semi_finals_a = p_semi_finals_a
	semi_finals_b = p_semi_finals_b
	final = p_final


func set_up(
	p_teams: Array[Team],
	p_legs_semi_finals: Legs = Legs.DOUBLE,
	p_legs_final: Legs = Legs.SINGLE,
) -> void:
	legs_semi_finals = p_legs_semi_finals
	legs_final = p_legs_final
	# sort teams by presitge
	p_teams.sort_custom(func(a: Team, b: Team) -> bool: return a.get_prestige() > b.get_prestige())

	# add teams alterning to part a/b
	for i: int in p_teams.size():
		if i % 2 == 0:
			teams_a.append(p_teams[i])
		else:
			teams_b.append(p_teams[i])


func get_matches(cup: Cup) -> Array[Array]:
	var matches: Array[Array] = []
	# semifinals
	if teams_a.size() > 1:
		var match_day: Array[Match] = []
		# group a
		for i: int in teams_a.size() / 2:
			# assign first vs last, first + 1 vs last - 1 etc...
			var matchz: Match = Match.new()
			matchz.set_up(teams_a[i], teams_a[-(i + 1)], cup.id, cup.name)
			match_day.append(matchz)
		# group b
		for i: int in teams_b.size() / 2:
			# assign first vs last, first + 1 vs last - 1 etc...
			var matchz: Match = Match.new()
			matchz.set_up(teams_b[i], teams_b[-(i + 1)], cup.id, cup.name)
			match_day.append(matchz)
		matches.append(match_day)
		
		# second leg
		if legs_semi_finals == Knockout.Legs.DOUBLE:
			var match_day_2: Array[Match] = []
			# iterate over all matches of match day 1 and invert home/away
			for matchz_1: Match in match_day:
				var matchz: Match = Match.new()
				matchz.set_up(matchz_1.away, matchz_1.home, cup.id, cup.name, matchz_1)
				match_day_2.append(matchz)
			matches.append(match_day_2)

	else:
		# final match
		var matchz: Match = Match.new()
		matchz.set_up(teams_a[0], teams_b[0], cup.id, cup.name)
		matches.append_array([matchz])
		
		# second leg
		if legs_final == Legs.DOUBLE:
			var matchz_2: Match = Match.new()
			matchz_2.set_up(teams_b[0], teams_a[0], cup.id, cup.name, matchz)
			matches.append_array([matchz_2])

	return matches


func prepare_next_round() -> bool:
	for matchz: Match in semi_finals_a + semi_finals_b:
		if not matchz.over:
			return false
	
	# eliminate teams
	var matches_to_check: int = teams_a.size() / 2 * (legs_semi_finals + 1)
	# teams a
	for i: int in range(-1 , -matches_to_check, -1):
		if legs_semi_finals == Legs.SINGLE:
			var matchz: Match = semi_finals_a[i]
			if matchz.home_goals > matchz.away_goals:
				teams_a.erase(matchz.away)
			else:
				teams_a.erase(matchz.home)
		else:
			var second_leg: Match = semi_finals_a[i]
			# search for matches with fist leg reference
			if second_leg.first_leg != null:
				var first_leg: Match = second_leg.first_leg
				
				var team_1_goal_sum: int = first_leg.home_goals + second_leg.away_goals
				var team_2_goal_sum: int = first_leg.away_goals + second_leg.home_goals

				if  team_1_goal_sum > team_2_goal_sum:
					teams_a.erase(first_leg.home)
				else:
					teams_a.erase(first_leg.away)

	return true
