# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum PlayerNames { MALE, FEMALE, MIXED }

const DEFAULT_SCALE: float = 1
const FONT_SIZE_DEFAULT: int = 18
const FONT_SIZE_MIN: int = 14
const FONT_SIZE_MAX: int = 26

# match engine
const HALF_TIME_SECONDS: int = 60 * 20
const TICKS_PER_SECOND: int = 4
const SPEED: int = 2
# stamina range [0, 1]
# this factor makes sure a player with attribute stamina 20
# can play a full game running all the time
const STAMINA_FACTOR: float = 1.0 / (HALF_TIME_SECONDS * 2 * TICKS_PER_SECOND)

const MAX_PRESTIGE: int = 20

const LINEUP_PLAYERS_AMOUNT: int = 12

# season start at 1st of june
const SEASON_START_DAY: int = 1
const SEASON_START_MONTH: int = 6

# STRINGS
const MONTH_STRINGS: Array[StringName] = [
	"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
]
const DAY_STRINGS: Array[StringName] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
const SURNAME: StringName = "SURNAME"
const POSITION: StringName = "POSITION"
