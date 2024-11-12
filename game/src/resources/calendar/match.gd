# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Match
extends JSONResource

@export var id: int
@export var home: Team
@export var away: Team
@export var over: bool
@export var home_goals: int
@export var away_goals: int
@export var competition_id: int
@export var competition_name: String


func _init(
	p_home: Team = Team.new(),
	p_away: Team = Team.new(),
	p_competition_id: int = -1,
	p_competition_name: String = "",
	p_home_goals: int = -1,
	p_away_goals: int = -1,
) -> void:
	home = p_home
	away = p_away
	competition_id = p_competition_id
	competition_name = p_competition_name
	home_goals = p_home_goals
	away_goals = p_away_goals
	id = IdUtil.next_id(IdUtil.Types.MATCH)


func set_result(p_home_goals: int, p_away_goals: int, world: World = Global.world) -> void:
	home_goals = p_home_goals
	away_goals = p_away_goals
	over = true

	# save in competition table/knockout
	# needs to be done here, so it can be used from match and dashboard
	if world:
		var competition: Competition = world.get_competition_by_id(competition_id)

		if competition is League:
			var league: League = (competition as League)
			league.table().add_result(home.id, home_goals, away.id, away_goals)
		elif competition is Cup:
			var cup: Cup = (competition as Cup)
			cup.add_result(home.id, home_goals, away.id, away_goals)
		else:
			print("error competition with no valid type; id: " + str(competition_id))


func get_result() -> String:
	if home_goals == -1 and away_goals == -1:
		return ""
	return str(home_goals) + " : " + str(away_goals)
