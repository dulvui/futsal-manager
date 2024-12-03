# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InputSettings
extends VBoxContainer


@onready var joypad_info: Label = %JoypadInfo
@onready var type_button: SwitchOptionButton = %TypeButton
@onready var detection_mode_button: SwitchOptionButton = %DetectionModeButton


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	# joypad info
	JoypadUtil.joypad_changed.connect(
		func() -> void:
			joypad_info.text = JoypadUtil.get_joypad_type_string()
	)
	joypad_info.text = JoypadUtil.get_joypad_type_string()

	# type
	type_button.setup(InputUtil.Type.keys(), Global.input_type)
	# detection mode
	detection_mode_button.setup(InputUtil.DetectionMode.keys(), Global.input_detection_mode)


func restore_defaults() -> void:
	# type
	Global.input_type = 0
	type_button.option_button.selected = 0
	# detection mode
	Global.input_detection_mode = 0
	detection_mode_button.option_button.selected = 0

	Global.save_config()


func _on_detection_mode_button_item_selected(index: int) -> void:
	Global.input_detection_mode = index
	if index == InputUtil.DetectionMode.MANUAL:
		InputUtil.type = Global.input_type
	Global.save_config()



func _on_type_button_item_selected(index: int) -> void:
	InputUtil.type = index
	Global.save_config()

