# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TestMatchCombination
extends Node

const TEAMS: int = 10


func test() -> void:
	print("test: match combination...")
	var league: League = create_mock_league()
	test_combinations(league)
	print("test: match combination done.")


func test_combinations(league: League) -> void:
	print("test: combinations...")
	var match_days: Array[Array] = MatchCombinationUtil.create_combinations(league, league.teams)

	# test that match amount is correct
	# every team plays agains each other team 2 times
	var reference_match_count: int = (TEAMS - 1) * 2 * (TEAMS / 2)
	var match_count: int = 0
	for match_day: Array in match_days:
		match_count += match_day.size()
	assert(reference_match_count == match_count)

	print("test: combinations done...")


func create_mock_league() -> League:
	var league: League = League.new()

	for i in range(TEAMS):
		var team: Team = Team.new()
		team.name = "Team " + str(i)
		team.players = [Player.new(), Player.new(), Player.new(), Player.new(), Player.new()]

		league.add_team(team)

	return league
