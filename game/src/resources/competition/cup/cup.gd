# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Cup
extends Competition

enum Stage {
	GROUP,
	KNOCKOUT,
}

const GROUPS: int = 4
const TEAMS_PASS_TO_KNOCKOUT: int = 2

@export var groups: Array[Group]
@export var knockout: Knockout
# includes also historical winners
# winners[-1] is latest winner
@export var winners: Array[Team]
@export var stage: Stage


func _init(
	p_groups: Array[Group] = [],
	p_knockout: Knockout = Knockout.new(),
	p_stage: Stage = Stage.GROUP,
) -> void:
	super()
	groups = p_groups
	knockout = p_knockout
	stage = p_stage


func set_up(p_teams: Array[Team]) -> void:
	stage = Stage.GROUP
	# sort teams by presitge
	p_teams.sort_custom(func(a: Team, b: Team) -> bool: return a.get_prestige() > b.get_prestige())

	# set up groups
	for i: int in GROUPS:
		var group: Group = Group.new()
		groups.append(group)
	# split teams in groups, according to prestige
	for i: int in p_teams.size():
		groups[i % GROUPS].add_team(p_teams[i])


func set_up_knockout(teams: Array[Team] = [], match_amount: int = 1) -> void:
	stage = Stage.KNOCKOUT
	# if coming from group stage
	if teams.size() == 0:
		# sort teams by table pos
		for group: Group in groups:
			group.sort_teams_by_table_pos()
		# add winning teams to knockout stage
		for group: Group in groups:
			teams.append_array(group.teams.slice(0, TEAMS_PASS_TO_KNOCKOUT))

	knockout.set_up(teams, match_amount)


func add_result(home_id: int, home_goals: int, away_id: int, away_goals: int) -> void:
	if stage == Stage.KNOCKOUT:
		knockout.add_result(home_id, home_goals, away_id, away_goals)
	else:
		var group: Group = _find_group_by_team_id(home_id)
		group.table.add_result(home_id, home_goals, away_id, away_goals)


func next_stage() -> void:
	if stage == Stage.GROUP:
		# check if group stage is over
		var over_counter: int = 0
		for group: Group in groups:
			if group.is_over():
				over_counter += 1
		if over_counter == groups.size():
			# group stage is over
			set_up_knockout()
			# add it to calendar
			return
	else:
		# check if current knockout stage is over 
		if knockout.teams_a.size() == knockout.teams_b.size() \
			and	knockout.teams_a.size() % 2 == 0:
			# add it to calendar
			return	



func get_group_matches() -> Array[Array]:
	var matches: Array[Array] = []

	for group: Group in groups:
		matches.append_array(MatchCombinationUtil.create_combinations(self, group.teams))
	
	return matches


func get_knockout_matches() -> Array[Array]:
	var matches: Array[Array] = []
	# semifinals
	if knockout.teams_a.size() > 1:
		for amount: int in knockout.match_amount:
			var match_day: Array[Match] = []
			# group a
			for i: int in knockout.teams_a.size() / 2:
				# assign first vs last, first + 1 vs last - 1 etc...
				var matchz: Match = Match.new(knockout.teams_a[i], knockout.teams_a[-(i + 1)], id, name)
				match_day.append(matchz)
			# group b
			for i: int in knockout.teams_b.size() / 2:
				# assign first vs last, first + 1 vs last - 1 etc...
				var matchz: Match = Match.new(knockout.teams_b[i], knockout.teams_b[-(i + 1)], id, name)
				match_day.append(matchz)
			matches.append(match_day)
	else:
		# final match
		var matchz: Match = Match.new(knockout.teams_a[0], knockout.teams_b[0], id, name)
		matches.append_array([matchz])

	return matches


func _find_group_by_team_id(team_id: int) -> Group:
	for group: Group in groups:
		if group.get_team_by_id(team_id) != null:
			return group
	print("error while seaerching team with id %s in group"%str(team_id))
	return null
