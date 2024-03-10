# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Nations { ITALY, SPAIN, ROMANIA }
enum Gender { MALE, FEMALE, MIXED }

const DEFAULT_SEED:String = "SuchDefaultSeed"

# match fast forward speed factor
const MATCH_SPEED_FACTOR:int = 8

# factor if shot becomes a visual action
const VISUAL_ACTION_SHOTS_FACTOR:int = 10

const DASHBOARD_DAY_DELAY:float = 0.5

# percentage of keeper saving shots
const GOAL_KEEPER_FACTOR:Dictionary = {
	"NORMAL" : 0.90,
	"FREE_KICK": 0.85,
	"PENALTY" : 0.6
}
# percentage of how weaker away keaper is
const GOAL_KEEPER_AWAY_FACTOR = 0.85

# 0 - 100
const MAX_FACTOR:int = 100
const CORNER_AFTER_SAFE_FACTOR:int = 20
const KICK_IN_FACTOR:int = 10

const FOUL_FACTOR:int = 2

# lower than PENALTY_FACTOR is free kick
const PENALTY_FACTOR:int = 5

const SHOOT_ON_TARGET_FACTOR:int = 70

# rest is no card
const YELLOW_CARD_FACTOR:int = 65
const RED_CARD_FACTOR:int = 90

# factor for defining attack (0 - 100)
const ATTACK_FACTOR:int = 1000
const PASS_FACTOR:int = 450
const RUN_FACTOR:int = 700
const DRIBBLE_FACTOR:int = 950
const SHOOT_FACTOR:int = 1000

# attack success factors
# bigger number => more success
const PASS_SUCCESS_FACTOR:int = 3 # attack 3 : 1 defense

const ATTRIBUTES:Dictionary = {
	"mental" : ["aggression","anticipation","decisions","concentration",
				"teamwork","vision","work_rate","offensive_movement","marking"],
	"physical" : ["pace","acceleration","stamina","strength", "agility","jump"],
	"goalkeeper": ["reflexes","positioning","kicking","handling","diving","speed"],
	"technical": ["crossing","passing","long_passing","tackling","heading","interception",
					"shooting","long_shooting","penalty","finishing","dribbling","blocking"],
}

const MAX_PRESTIGE:int = 20

# simluations

## market

# random team requests own players
# 1/REQUEST_FACTOR = probability
const REQUEST_FACTOR: int = 20

const LINEUP_PLAYERS_AMOUNT = 12

const month_strings:Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
const day_strings:Array = ["SUN","MON","TUE","WE","THU","FRI","SAT"]
