# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ColorLabel
extends Label

@export var value_name: String

func setup(p_value_name: String) -> void:
	value_name = p_value_name
	tooltip_text = value_name


func set_value(value: Variant) -> void:
	text = str(value)

	if is_instance_of(value, TYPE_INT):
		if not label_settings:
			label_settings = LabelSettings.new()
			label_settings.outline_size = 2

		if value < 11:
			#label_settings.font_color = Color.RED
			label_settings.outline_color = Color.RED
		elif value < 16:
			#label_settings.font_color = Color.BLUE
			label_settings.outline_color = Color.BLUE
		else:
			#label_settings.font_color = Color.DARK_GREEN
			label_settings.outline_color = Color.DARK_GREEN

	# check if not number, treadet as string
	elif is_instance_of(value, TYPE_STRING) and not (value as String).is_valid_int():
		horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

