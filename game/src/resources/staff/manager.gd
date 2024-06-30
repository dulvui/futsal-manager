# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Manager
extends Person

func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.MANAGER),
	p_nationality: String = "",
	p_name: String = "",
	p_surname: String = "",
	p_prestige: int = 10
) -> void:
	id = p_id
	nationality = p_nationality
	name = p_name
	surname = p_surname
	prestige = p_prestige
	
	role = Person.Role.MANAGER

func get_full_name() -> String:
	return name + " " + surname
