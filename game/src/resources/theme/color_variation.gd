
# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ColorVariation
extends Resource


@export var normal: Color
@export var pressed: Color
@export var hover: Color
@export var focus: Color
@export var disabled: Color


func _init(color: Color) -> void:
	normal = color
	focus = color.lightened(0.1)
	pressed = color.darkened(0.1)
	hover = color.lightened(0.2)
	disabled = color.darkened(0.4)
