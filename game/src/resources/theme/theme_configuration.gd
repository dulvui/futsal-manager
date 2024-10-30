# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ThemeConfiguration
extends JSONResource


@export var id: int
@export var name: String

@export var font_color: Color
@export var button_color: Color 
@export var panel_color: Color

var font_color_normal: Color
var font_color_pressed: Color
var font_color_hover: Color
var font_color_focus: Color
var font_color_disabled: Color

var button_color_normal: Color
var button_color_pressed: Color
var button_color_focus: Color
var button_color_hover: Color
var button_color_disabled: Color


func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.THEME),
	p_name: String = "",
	p_font_color: Color = Color.BLACK,
	p_button_color: Color = Color.RED,
	p_panel_color: Color = Color.WHITE,
) -> void:
	id = p_id
	name = p_name
	font_color = p_font_color
	button_color = p_button_color
	panel_color = p_panel_color


func set_up() -> void:
	print(button_color)
	print(font_color)
	print(panel_color)

	# variations
	font_color_normal = font_color
	font_color_pressed = font_color.darkened(0.1)
	font_color_disabled = font_color.lightened(0.2)
	font_color_focus = font_color.darkened(0.1)
	font_color_hover = font_color.lightened(0.1)

	button_color_normal = button_color
	button_color_pressed = button_color.darkened(0.4)
	button_color_focus = button_color.lightened(0.3)
	button_color_hover = button_color.lightened(0.2)
	button_color_disabled = button_color.darkened(0.7)
