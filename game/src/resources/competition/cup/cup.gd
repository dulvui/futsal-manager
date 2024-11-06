# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Cup
extends Competition

const GROUPS: int = 4
const TEAMS_PASS_TO_KNOCKOUT: int = 2

@export var groups: Array[Group]
@export var knockout: Knockout
# includes also historical winners
# winners[-1] is latest winner
@export var winners: Array[Team]


func _init(
	p_groups: Array[Group] = [],
	p_knockout: Knockout = Knockout.new(),
) -> void:
	super()
	groups = p_groups
	knockout = p_knockout


func set_up(p_teams: Array[Team]) -> void:
	# sort teams by presitge
	p_teams.sort_custom(func(a: Team, b: Team) -> bool: return a.get_prestige() > b.get_prestige())

	# set up groups
	for i: int in GROUPS:
		var group: Group = Group.new()
		groups.append(group)
	# split teams in groups, according to prestige
	for i: int in p_teams.size():
		groups[i % GROUPS].add_team(p_teams[i])


func set_up_knockout(teams: Array[Team] = []) -> void:
	# if coming from group stage
	if teams.size() == 0:
		# sort teams by table pos
		for group: Group in groups:
			group.sort_teams_by_table_pos()

		# add winning teams to knockout stage
		for group: Group in groups:
			teams.append_array(group.teams.slice(0, TEAMS_PASS_TO_KNOCKOUT))

	knockout.set_up(teams)


func get_group_matches() -> Array[Array]:
	var matches: Array[Array] = []

	for group: Group in groups:
		matches.append_array(MatchCombinationUtil.create_combinations(self, group.teams))
	
	return matches


func get_knockout_matches() -> Array[Match]:
	var matches: Array[Match] = []
	# semifinals
	if knockout.teams_a.size() > 1:
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
	else:
		# final match
		var matchz: Match = Match.new(knockout.teams_a[0], knockout.teams_b[0], id, name)
		matches.append(matchz)

	return matches


func eliminate_team(team: Team) -> void:
	knockout.teams_a.erase(team)
	knockout.teams_b.erase(team)
