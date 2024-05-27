# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ColorNumber
extends Label

@export var value_name: String

func _ready() -> void:
	if value_name:
		tooltip_text = value_name


func set_up(p_value_name: String) -> void:
	value_name = p_value_name


func set_value(value: int) -> void:
	text = str(value)
	
	if not label_settings:
		label_settings = LabelSettings.new()
	
	if value < 11:
		label_settings.font_color = Color.RED
	elif value < 16:
		label_settings.font_color = Color.BLUE
	else:
		label_settings.font_color = Color.DARK_GREEN
