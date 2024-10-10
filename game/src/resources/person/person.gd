# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Person
extends Resource

enum Role {
	UNEMPLOYED,
	PLAYER,
	MANAGER,
	PRESIDENT,
	SCOUT,
	AGENT,
}

@export var id: int
@export var nation: String
@export var name: String
@export var surname: String
@export var birth_date: Dictionary
@export var prestige: int  # 1-20
@export var role: Role
@export var contract: Contract


func _init(
	p_role: Role = Role.UNEMPLOYED,
	p_id: int = IdUtil.next_id(IdUtil.Types.PERSON),
	p_nation: String = "",
	p_name: String = "",
	p_surname: String = "",
	p_birth_date: Dictionary = Time.get_datetime_dict_from_system(),
	p_prestige: int = 10,
	p_contract: Contract = Contract.new(),
) -> void:
	role = p_role
	id = p_id
	nation = p_nation
	name = p_name
	surname = p_surname
	birth_date = p_birth_date
	prestige = p_prestige
	contract = p_contract


func get_full_name() -> String:
	return name + " " + surname


func get_age(date: Dictionary = Global.start_date) -> int:
	return date.year - birth_date.year


func get_salary() -> int:
	return contract.income
