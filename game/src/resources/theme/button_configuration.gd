# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ButtonConfiguration
extends JSONResource


@export var font_color: Color
@export var normal_bg_color: Color
@export var pressed_bg_color: Color

func _init(
	p_font_color: Color = Color(1.0, 1.0, 1.0, 1.0),
	p_normal_bg_color: Color = Color(1.0, 1.0, 1.0, 1.0),
	p_pressed_bg_color: Color = Color(1.0, 1.0, 1.0, 1.0),
) -> void:
	font_color = p_font_color
	normal_bg_color = p_normal_bg_color
	pressed_bg_color = p_pressed_bg_color
