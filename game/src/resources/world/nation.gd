# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Nation
extends Resource

@export var name: String
@export var leagues: Array[League]
@export var cup: CupKnockout
@export var team: Team

# teams that are not playing in a league at the moment
# they will get promoted, as soon as a team gets delegated from the last league
@export var backup_teams: Array[Team]


func _init(
	p_name: String = "",
	p_leagues: Array[League] = [],
	p_cup: CupKnockout = CupKnockout.new(),
	p_team: Team = Team.new(),
	p_backup_teams: Array[Team] = [],
) -> void:
	name = p_name
	leagues = p_leagues
	cup = p_cup
	team = p_team
	backup_teams = p_backup_teams


func add_league(league: League) -> void:
	leagues.append(league)


func get_league_by_id(league_id: int) -> League:
	for league: League in leagues:
		if league.id == league_id:
			return league
	return null


func get_league_by_pyramid_level(pyramid_level: int) -> League:
	for league: League in leagues:
		if league.pyramid_level == pyramid_level:
			return league
	return null


func get_team_by_id(team_id: int) -> Team:
	for league: League in leagues:
		var found_team: Team = league.get_team_by_id(team_id)
		if found_team:
			return found_team
	print("ERROR: team not found with id: " + str(team_id))
	return null


func random_results() -> void:
	var match_engine: MatchEngine = MatchEngine.new()
	for league: League in leagues:
		var matches: Array = Config.world.calendar.day().get_matches(league.id)
		for matchz: Match in matches:
			if not matchz.over:
				var result_match: Match = match_engine.simulate(matchz)
				matchz.set_result(result_match.home_goals, result_match.away_goals)
