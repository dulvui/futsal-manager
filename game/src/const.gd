# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Nations { ITALY, SPAIN, ROMANIA }
enum Gender { MALE, FEMALE, MIXED }

# match engine
const HALF_TIME_SECONDS: int = 60 * 20
const TICKS_PER_SECOND: int = 4
const SPEED: int = TICKS_PER_SECOND / 2

const ATTRIBUTES: Dictionary = {
	"mental":
	[
		"aggression",
		"anticipation",
		"decisions",
		"concentration",
		"teamwork",
		"vision",
		"work_rate",
		"offensive_movement",
		"marking"
	],
	"physical": ["pace", "acceleration", "stamina", "strength", "agility", "jump"],
	"goalkeeper": ["reflexes", "positioning", "kicking", "handling", "diving", "speed"],
	"technical":
	[
		"crossing",
		"passing",
		"long_passing",
		"tackling",
		"heading",
		"interception",
		"shooting",
		"long_shooting",
		"penalty",
		"finishing",
		"dribbling",
		"blocking"
	],
}

const MAX_PRESTIGE: int = 20

const LINEUP_PLAYERS_AMOUNT:int = 12

const MONTH_STRINGS: Array = [
	"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OKT", "NOV", "DEC"
]
const DAY_STRINGS: Array = ["SUN", "MON", "TUE", "WE", "THU", "FRI", "SAT"]

# season start at 1st of june
const SEASON_START_DAY: int = 1
const SEASON_START_MONTH: int = 6
