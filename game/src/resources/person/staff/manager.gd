# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Manager
extends Person

@export var agent: Agent

func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.MANAGER),
	p_nation: String = "",
	p_name: String = "",
	p_surname: String = "",
	p_birth_date: Dictionary = Time.get_datetime_dict_from_system(),
	p_prestige: int = 10,
	p_agent: Agent = Agent.new(),
) -> void:
	id = p_id
	nation = p_nation
	name = p_name
	surname = p_surname
	birth_date = p_birth_date
	prestige = p_prestige
	agent = p_agent
	
	role = Person.Role.MANAGER
