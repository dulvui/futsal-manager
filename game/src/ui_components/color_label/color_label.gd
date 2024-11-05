# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ColorLabel
extends MarginContainer

signal select

@export var value_name: String
@onready var label: Label = $Label
@onready var button: Button = $Button


func set_up(p_value_name: String, is_button: bool = false) -> void:
	value_name = p_value_name

	button.disabled = not is_button
	button.visible = is_button

	tooltip_text = value_name


func set_value(value: Variant) -> void:
	if not button.disabled:
		button.text = str(value)
	else:
		label.text = str(value)

		if is_instance_of(value, TYPE_INT):
			if not label.label_settings:
				label.label_settings = LabelSettings.new()
				label.label_settings.outline_size = 2

			if value < 11:
				#label.label_settings.font_color = Color.RED
				label.label_settings.outline_color = Color.RED
			elif value < 16:
				#label.label_settings.font_color = Color.BLUE
				label.label_settings.outline_color = Color.BLUE
			else:
				#label.label_settings.font_color = Color.DARK_GREEN
				label.label_settings.outline_color = Color.DARK_GREEN

		# check if not number, treadet as string
		elif is_instance_of(value, TYPE_STRING) and not (value as String).is_valid_int():
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT


func _on_button_pressed() -> void:
	select.emit()
