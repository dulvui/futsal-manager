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
@export var nr:int # shirt number
@export var loyality:int
@export var prestige:int # 1-100
@export var moral:int
@export var injury_factor:int
@export var name:String
@export var team:String # team name for easier filtering etc...
@export var league:String # league name for easier filtering etc...
@export var surname:String
@export var nationality:String
@export var birth_date:Dictionary
@export var form:Form
@export var morality:Morality
@export var statistics:Array[Statistics]
@export var foot:Foot
@export var position:Position
@export var contract:Contract
@export var attributes:Attributes

func _init(
	p_id:int = IdUtil.next_id(IdUtil.Types.PLAYER),
	p_price:int = 0,
	p_nr:int = 0,
	p_loyality:int = 0,
	p_prestige:int = 0,
	p_moral:int = 0,
	p_injury_factor:int = 0,
	p_name:String = "",
	p_team:String = "",
	p_league:String = "",
	p_surname:String = "",
	p_nationality:String = "",
	p_birth_date:Dictionary = {},
	p_form:Form = Form.Good,
	p_morality:Morality = Morality.Good,
	p_statistics:Array[Statistics] = [],
	p_foot:Foot = Foot.R,
	p_position:Position = Position.G,
	p_contract:Contract = Contract.new(),
	p_attributes:Attributes = Attributes.new(),
) -> void:
	id = p_id
	price = p_price
	nr = p_nr
	loyality = p_loyality
	prestige = p_prestige
	moral = p_moral
	injury_factor = p_injury_factor
	name = p_name
	team = p_team
	league = p_league
	surname = p_surname
	nationality = p_nationality
	birth_date = p_birth_date
	form = p_form
	morality = p_morality
	statistics = p_statistics
	foot = p_foot
	position = p_position
	contract = p_contract
	attributes = p_attributes


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
