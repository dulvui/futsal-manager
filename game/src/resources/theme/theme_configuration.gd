# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ThemeConfiguration
extends JSONResource


@export var id: int
@export var name: String
@export var font_color: Color
@export var button: ButtonConfiguration
@export var panel_color: Color

func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.THEME),
	p_name: String = "",
	p_font_color: Color = Color(1.0, 1.0, 1.0, 1.0),
	p_button: ButtonConfiguration = ButtonConfiguration.new(),
	p_panel_color: Color = Color.WHITE,
) -> void:
	id = p_id
	name = p_name
	font_color = p_font_color
	button = p_button
	panel_color = p_panel_color
