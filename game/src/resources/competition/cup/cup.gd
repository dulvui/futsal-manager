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


func set_up_knockout(
	teams: Array[Team] = [],
	legs_semi_finals: Knockout.Legs = Knockout.Legs.DOUBLE,
	legs_final: Knockout.Legs = Knockout.Legs.SINGLE,
) -> void:
	stage = Stage.KNOCKOUT
	# if coming from group stage
	if teams.size() == 0:
		# sort teams by table pos
		for group: Group in groups:
			group.sort_teams_by_table_pos()
		# add winning teams to knockout stage
		for group: Group in groups:
			teams.append_array(group.teams.slice(0, TEAMS_PASS_TO_KNOCKOUT))

	knockout.set_up(teams, legs_semi_finals, legs_final)


func add_result(home_id: int, home_goals: int, away_id: int, away_goals: int) -> void:
	if stage == Stage.GROUP:
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
			MatchCombinationUtil.add_matches_to_calendar(self, get_knockout_matches())
	else:
		if knockout.prepare_next_round():
			# add next round matches calendar
			MatchCombinationUtil.add_matches_to_calendar(self, get_knockout_matches())


func get_group_matches() -> Array[Array]:
	var matches: Array[Array] = []

	for group: Group in groups:
		matches.append_array(MatchCombinationUtil.create_combinations(self, group.teams))
	
	return matches


func get_knockout_matches() -> Array[Array]:
	return knockout.get_matches(self)

func _find_group_by_team_id(team_id: int) -> Group:
	for group: Group in groups:
		if group.get_team_by_id(team_id) != null:
			return group
	print("error while seaerching team with id %s in group"%str(team_id))
	return null
