# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InputSettings
extends VBoxContainer


@onready var joypad_info: Label = %JoypadInfo


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	JoypadUtil.joypad_changed.connect(
		func() -> void:
			joypad_info.text = JoypadUtil.get_joypad_type_string()
	)

	joypad_info.text = JoypadUtil.get_joypad_type_string()


func restore_defaults() -> void:
	pass
