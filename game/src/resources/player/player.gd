# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Player
extends Resource

enum Position {G, D, W, U, P}
enum Foot {L, R}
enum Morality {Horrible, Bad, Good, Excellent}
enum Form {Injured, Recover, Good, Excellent}

@export var id:int
@export var price:int
# shirt number
@export var nr:int
@export var name:String
# team name for easier filtering etc...
@export var team:String
@export var surname:String
@export var birth_date:Dictionary
@export var nationality:String
@export var position:Position
@export var foot:Foot
@export var loyality:int
@export var contract:Contract
@export var statistics:Array[Statistics]
@export var attributes:Attributes

@export var form:Form
@export var prestige:int # 1-100
@export var morality:Morality
@export var moral:int
@export var injury_factor:int

func get_full_name() -> String:
	return name + " " + surname

func get_attack_attributes(attack:Action.Attack) -> int:
	match attack:
		Action.Attack.SHOOT:
			# check sector and pick long_shoot
			return attributes.technical.shooting
		Action.Attack.PASS:
			return attributes.technical.passing * Constants.PASS_SUCCESS_FACTOR
#		Action.Attack.CROSS:
#			return attributes.technical.crossing
		Action.Attack.DRIBBLE:
			return attributes.technical.dribbling
#		Action.Attack.HEADER:
#			return attributes.technical.heading"]
		Action.Attack.RUN:
			var attacker_attributes:int =  attributes.physical.pace
			attacker_attributes += attributes.physical.acceleration
			return attacker_attributes
	# should never happen
	return -1


func get_defense_attributes(attack:Action.Attack) -> int:
	match attack:
		Action.Attack.SHOOT:
			# check sector and pick long_shoot
			return attributes.technical.blocking
		Action.Attack.PASS:
			return attributes.technical.interception
#		Action.Attack.CROSS:
#			return attributes.technical.interception"]
		Action.Attack.DRIBBLE:
			return attributes.technical.tackling
#		Action.Attack.HEADER:
#			return attributes.technical.heading"]
		# use player preferences/attirbutes and team tactics pressing or wait
		Action.Attack.RUN:
			var defender_attributes:int
			if randi() % 2 == 0:
#					return Defense.RUN
				defender_attributes = attributes.physical.pace
				defender_attributes += attributes.physical.acceleration
			else:
#					return Defense.TACKLE
				defender_attributes = attributes.technical.tackling
				defender_attributes += attributes.physical.pace

			return defender_attributes
	# should never happen
	return -1

func get_goalkeeper_attributes() -> int:
	var value:int = 0
	value += attributes.goalkeeper.reflexes
	value += attributes.goalkeeper.positioning
	value += attributes.goalkeeper.kicking
	value += attributes.goalkeeper.handling
	value += attributes.goalkeeper.diving
	value += attributes.goalkeeper.speed
	return value
