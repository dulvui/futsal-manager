# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MatchStatistics
extends Resource

var goals:int = 0
var possession:int = 50
var shots:int = 0
var shots_on_target:int = 0
var passes:int = 0
var passes_success:int = 0
var kick_ins:int = 0
var free_kicks:int = 0
var penalties:int = 0
var penalty_kick:int = 0 # after 6 fouls
var fouls:int = 0
var tackles:int = 0
var tackles_success:int = 0
var corners:int = 0
var headers:int = 0
var headers_on_target:int = 0
var yellow_cards:int = 0
var red_cards:int = 0
