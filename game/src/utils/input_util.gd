# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal search

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

const ACTION_SEARCH: StringName = "SEARCH"
const ACTION_CONTINUE: StringName = "CONTINUE"

var focused: bool = true
var viewport: Viewport
var last_focused_node: Control

func _ready() -> void:
	viewport = get_viewport()
	# register view port focus changed signal
	viewport.gui_focus_changed.connect(_on_gui_focus_change)
	InputMap.add_action(ACTION_SEARCH)
	# keyboard
	var continue_key: InputEventKey = InputEventKey.new()
	continue_key.keycode = KEY_W
	# joypad
	var continue_joypad: InputEventJoypadButton = InputEventJoypadButton.new()
	continue_joypad.button_index = JOY_BUTTON_START
	

	# keyboard
	var search_key: InputEventKey = InputEventKey.new()
	search_key.keycode = KEY_F
	search_key.ctrl_pressed = true
	InputMap.action_add_event(ACTION_SEARCH, search_key)
	# vim
	var search_vim: InputEventKey = InputEventKey.new()
	search_vim.keycode = KEY_SLASH
	InputMap.action_add_event(ACTION_SEARCH, search_vim)
	# joypad
	var search_joypad: InputEventJoypadButton = InputEventJoypadButton.new()
	search_joypad.button_index = JOY_BUTTON_Y
	InputMap.action_add_event(ACTION_SEARCH, search_joypad)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true


func _input(event: InputEvent) -> void:
	if focused:
		# check if a nodes has focus. if not, last focused node grabs it
		if viewport.gui_get_focus_owner() == null:
			if last_focused_node != null:
				print("regrab last focus")
				last_focused_node.grab_focus()
			else:
				print("not able to regrab focus")

		# check for actions
		if event.is_action_pressed(ACTION_SEARCH):
			print("search pressed")
			search.emit()
			# Register the event as handled and stop polling
			get_viewport().set_input_as_handled()
		return

	if event is InputEventJoypadButton or event is InputEventKey:
		print("not focused event prevented")


func start_focus(control: Control) -> void:
	# check if control can't be focused
	if control.focus_mode == control.FOCUS_NONE:
		# find next control to focus
		var next_focus: Control = control.find_next_valid_focus()
		if next_focus:
			next_focus.grab_focus()
	else:
		# focus control
		control.grab_focus()

func _on_gui_focus_change(node: Control) -> void:
	last_focused_node = node
