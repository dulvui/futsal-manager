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

var focused: bool = true


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true


func _input(event: InputEvent) -> void:
	if focused:
		if event is InputEventJoypadButton:
			print("controller")
		if event is InputEventKey:
			print("keyboard")
		if event.is_action_pressed("search"):
			print("search pressed")
			search.emit()
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


func event_is_action_pressed(event: InputEvent, action: StringName) -> bool:
	if focused:
		return event.is_action_pressed(action)

	return false
