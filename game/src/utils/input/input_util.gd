# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# signal search
signal type_changed(type: Type)

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

enum Type {
	JOYPAD,
	KEYBOARD,
	#VIRTUAL_KEYBOARD,
	TOUCH,
}

const ACTION_SEARCH: StringName = "SEARCH"
const ACTION_CONTINUE: StringName = "CONTINUE"

var focused: bool
var type: Type
var viewport: Viewport
var first_focus: Control
var last_focus: Control


func _ready() -> void:
	focused = true
	type = Type.KEYBOARD
	viewport = get_viewport()
	viewport.gui_focus_changed.connect(_on_gui_focus_change)

	_setup_actions()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true


func _input(event: InputEvent) -> void:
	if focused:
		
		# only verify focus, when pressed
		if event.is_pressed():
			_verify_focus()

		_verify_joypad(event)

		# check for actions
		# if event.is_action_pressed(ACTION_SEARCH):
		# 	print("search pressed")
		# 	search.emit()
		# 	# Register the event as handled and stop polling
		# 	get_viewport().set_input_as_handled()
		return
	else:
		get_viewport().set_input_as_handled()


func start_focus(node: Control) -> void:
	first_focus = node
	# check if control can't be focused
	if node.focus_mode == node.FOCUS_NONE:
		# find next control to focus
		first_focus = node.find_next_valid_focus()
	
	if first_focus:
		first_focus.grab_focus()
	else:
		print("start focus: not node found to focus")


func _setup_actions() -> void:
	# continue
	InputMap.add_action(ACTION_CONTINUE)
	var continue_key: InputEventKey = InputEventKey.new()
	continue_key.keycode = KEY_W
	InputMap.action_add_event(ACTION_CONTINUE, continue_key)
	var continue_joypad: InputEventJoypadButton = InputEventJoypadButton.new()
	continue_joypad.button_index = JOY_BUTTON_START
	
	# # search
	# InputMap.add_action(ACTION_SEARCH)
	# var search_key: InputEventKey = InputEventKey.new()
	# search_key.keycode = KEY_F
	# search_key.ctrl_pressed = true
	# InputMap.action_add_event(ACTION_SEARCH, search_key)
	# var search_vim: InputEventKey = InputEventKey.new()
	# search_vim.keycode = KEY_SLASH
	# InputMap.action_add_event(ACTION_SEARCH, search_vim)
	# var search_joypad: InputEventJoypadButton = InputEventJoypadButton.new()
	# search_joypad.button_index = JOY_BUTTON_Y
	# InputMap.action_add_event(ACTION_SEARCH, search_joypad)


func _verify_focus() -> void:
	# check if a nodes has focus, if not, last or first focused node grabs it
	if viewport.gui_get_focus_owner() == null:
		if last_focus != null and last_focus.is_inside_tree():
			print("regrab last focus")
			last_focus.grab_focus()
		elif first_focus != null and first_focus.is_inside_tree():
			first_focus.grab_focus()
		else:
			print("not able to regrab focus")


func _verify_joypad(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if type != Type.JOYPAD:
			type = Type.JOYPAD
			type_changed.emit(Type.JOYPAD)
	else:
		if type != Type.KEYBOARD:
			type = Type.KEYBOARD
			type_changed.emit(Type.KEYBOARD)


func _on_gui_focus_change(node: Control) -> void:
	last_focus = node

