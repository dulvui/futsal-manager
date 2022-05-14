extends Node


# match fast forward speed factor
const MATCH_SPEED_FACTOR = 4

# bigger number => more saves
const GOAL_KEEPER_FACTOR = 15

# 0 - 100
const MAX_FACTOR = 100
const CORNER_AFTER_SAFE_FACTOR = 20


# factor for defining attack (0 - 100)
const ATTACK_FACTOR = 1000
const RUN_FACTOR = 450
const PASS_FACTOR = 900
const DRIBBLE_FACTOR = 950
const SHOOT_FACTOR = 1000

# attack success factors
# bigger number => more success
const PASS_SUCCESS_FACTOR = 3 # attack 3 : 1 defense

const ATTRIBUTES = {
	"mental" : ["aggression","anticipation","decisions","concentration",
				"teamwork","vision","work_rate","offensive_movement","marking"],
	"physical" : ["pace","acceleration","stamina","strength", "agility","jump"],
	"goalkeeper": ["reflexes","positioning","kicking","handling","diving","speed"],
	"technical": ["crossing","passing","long_passing","tackling","heading","interception",
					"shooting","long_shooting","penalty","finishing","dribbling","blocking"],
}

