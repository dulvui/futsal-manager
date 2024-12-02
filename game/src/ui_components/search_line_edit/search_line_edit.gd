# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name DefaultLineEdit
extends LineEdit


@onready var joypad_shortcut: Button = %JoypadShortcut
@onready var keyboard_shortcut: Button = %KeyboardShortcut


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	_shortcut_visibility(true)
	
	InputUtil.type_changed.connect(_on_input_type_changed)
	
	joypad_shortcut.text = JoypadUtil.get_button_sign(JOY_BUTTON_Y)


func _shortcut_visibility(p_visible: bool) -> void:
	if InputUtil.type == InputUtil.Type.KEYBOARD:
		joypad_shortcut.visible = false
		keyboard_shortcut.visible = p_visible
	elif InputUtil.type == InputUtil.Type.JOYPAD:
		keyboard_shortcut.visible = false
		joypad_shortcut.visible = p_visible


func _on_input_type_changed(_type: InputUtil.Type) -> void:
	_shortcut_visibility(not has_focus())
	joypad_shortcut.text = JoypadUtil.get_button_sign(JOY_BUTTON_Y)


func _on_focus_entered() -> void:
	_shortcut_visibility(false)


func _on_focus_exited() -> void:
	_shortcut_visibility(true)


func _on_shortcut_button_pressed() -> void:
	grab_focus()


