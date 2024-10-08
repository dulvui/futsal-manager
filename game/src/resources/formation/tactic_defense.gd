# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TacticDefense
extends Resource

enum Marking {
	ZONE,
	PLAYER,
}

enum Pressing {
	NO_PRESS,
	HALF_COURT,
	FULL_COURT,
}

@export var marking: Marking
@export var pressing: Pressing


func _init(
	p_marking: Marking = Marking.ZONE,
	p_pressing: Pressing = Pressing.NO_PRESS,
) -> void:
	marking = p_marking
	pressing = p_pressing
