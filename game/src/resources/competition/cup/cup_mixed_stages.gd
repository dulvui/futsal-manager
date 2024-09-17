# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CupMixedStage
extends Competition

const GROUPS_SIZE: int = 4
const TEAMS_PASS_TO_KNOCKOUT: int = 2

@export var groups: Array[Group]
@export var knockout: Knockout

func _init(
	p_groups: Array[Group] = [],
	p_knockout: Knockout = Knockout.new(),
) -> void:
	super()
	groups = p_groups
	knockout = p_knockout


func add_teams(p_teams: Array[Team]) -> void:
	# sort teams by presitge
	p_teams.sort_custom(
		func(a: Team, b: Team) -> bool:
			return a.get_prestige() > b.get_prestige()
			)
	
	# set up groups
	for i: int in GROUPS_SIZE:
		var group: Group = Group.new()
		groups.append(group)
	# split teams in groups, according to prestige
	for i: int in p_teams.size():
		groups[i % GROUPS_SIZE].add_team(p_teams[i])


func setup_knockout() -> void:
	var knockout_teams: Array[Team] = []
	
	# sort teams by table pos
	for group: Group in groups:
		group.sort_teams_by_table_pos()
	
	# add winning teams to knockout stage
	for group: Group in groups:
		knockout_teams.append_array(group.teams.slice(0, TEAMS_PASS_TO_KNOCKOUT))
	
	knockout.set_up(knockout_teams)
