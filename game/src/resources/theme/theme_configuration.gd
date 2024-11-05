# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ThemeConfiguration
extends Resource

@export var id: int
@export var name: String

@export var font_color: Color
@export var style_color: Color
@export var background_color: Color

var font_color_normal: Color
var font_color_pressed: Color
var font_color_hover: Color
var font_color_focus: Color
var font_color_disabled: Color

var style_color_normal: Color
var style_color_pressed: Color
var style_color_focus: Color
var style_color_hover: Color
var style_color_disabled: Color


func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.THEME),
	p_name: String = "",
	p_font_color: Color = Color.BLACK,
	p_style_color: Color = Color.RED,
	p_background_color: Color = Color.WHITE,
) -> void:
	id = p_id
	name = p_name
	font_color = p_font_color
	style_color = p_style_color
	background_color = p_background_color


func set_up() -> void:
	# variations
	font_color_normal = font_color
	font_color_focus = font_color
	font_color_pressed = font_color.darkened(0.1)
	font_color_hover = font_color.lightened(0.1)
	font_color_disabled = font_color.lightened(0.4)

	style_color_normal = style_color
	style_color_focus = style_color.lightened(0.1)
	style_color_pressed = style_color.darkened(0.1)
	style_color_hover = style_color.lightened(0.2)
	style_color_disabled = style_color.darkened(0.4)
