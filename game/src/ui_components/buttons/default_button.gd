# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name DefaultButton
extends Button


@export var button_index: JoyButton = JOY_BUTTON_INVALID
@export var axis_index: JoyAxis = JOY_AXIS_INVALID


func _ready() -> void:
	tooltip_text = text
	icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	alignment = HORIZONTAL_ALIGNMENT_LEFT

	_setup_shortcut()
	
	InputUtil.type_changed.connect(_on_input_type_changed)


func _pressed() -> void:
	SoundUtil.play_button_sfx()


func _on_input_type_changed(_type: InputUtil.Type) -> void:
	_setup_shortcut()


func _setup_shortcut() -> void:
	if InputUtil.type == InputUtil.Type.JOYPAD and button_index != JOY_BUTTON_INVALID:
		icon = JoypadUtil.get_button_icon(button_index)
		var joypad_event: InputEventJoypadButton = InputEventJoypadButton.new()
		joypad_event.button_index = button_index

		shortcut = Shortcut.new()
		shortcut.events.append(joypad_event)
	else:
		icon = null
		shortcut = null


