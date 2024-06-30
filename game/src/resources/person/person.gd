# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Person
extends Resource

enum Role {
	PLAYER,
	MANAGER,
	PRESIDENT,
	SCOUT
}

@export var id: int
@export var nationality: String
@export var name: String
@export var surname: String
@export var prestige: int  # 1-20
@export var role: Role
@export var contract: Contract


func _init(
	p_nationality: String = "",
	p_name: String = "",
	p_surname: String = "",
	p_prestige: int = 10,
	p_role: Role = Role.PLAYER,
	p_contract: Contract = Contract.new(),
) -> void:
	nationality = p_nationality
	name = p_name
	surname = p_surname
	prestige = p_prestige
	role = p_role
	contract = p_contract


func get_full_name() -> String:
	return name + " " + surname


func get_salary() -> int:
	return contract.income
