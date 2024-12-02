# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal joypad_changed


enum Type {
	PLAYSTATION,
	XBOX,
	NINTENDO,
	STEAM,
	GENERIC,
}


const BUTTON_MAPPING: Dictionary = {
	Type.PLAYSTATION: {
		JOY_BUTTON_A: "\u21E3", # cross
		JOY_BUTTON_B: "\u21E2", # circle
		JOY_BUTTON_X: "\u21E0", # square
		JOY_BUTTON_Y: "\u21E1", # triangle
		JOY_BUTTON_LEFT_SHOULDER: "\u21B0", # l1
		JOY_BUTTON_RIGHT_SHOULDER: "\u21B1", # r1
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
	Type.XBOX: {
		JOY_BUTTON_A: "\u21D3", # a 
		JOY_BUTTON_B: "\u21D2", # b
		JOY_BUTTON_X: "\u21D0", # x
		JOY_BUTTON_Y: "\u21D1", # y
		JOY_BUTTON_LEFT_SHOULDER: "\u2198", # lb
		JOY_BUTTON_RIGHT_SHOULDER: "\u2199", # rb
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
	Type.NINTENDO: {
		JOY_BUTTON_A: "\u21D2", # b
		JOY_BUTTON_B: "\u21D3", # a
		JOY_BUTTON_X: "\u21D1", # y
		JOY_BUTTON_Y: "\u21D0", # x
		JOY_BUTTON_LEFT_SHOULDER: "\u219C", # l
		JOY_BUTTON_RIGHT_SHOULDER: "\u219D", # r
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
	Type.GENERIC: {
		JOY_BUTTON_A: "\u24F5", # 1
		JOY_BUTTON_B: "\u24F6", # 2
		JOY_BUTTON_X: "\u24F7", # 3
		JOY_BUTTON_Y: "\u24F8", # 4
		JOY_BUTTON_LEFT_SHOULDER: "\u24F9", # 5 
		JOY_BUTTON_RIGHT_SHOULDER: "\u24FA", # 6
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
}

const AXIS_MAPPING: Dictionary = {
	Type.PLAYSTATION: {
		JOY_AXIS_TRIGGER_LEFT: "\u21B2", # r2
		JOY_AXIS_TRIGGER_RIGHT: "\u21B3", # l2
	},
	Type.XBOX: {
		JOY_AXIS_TRIGGER_LEFT: "\u2196", # lt
		JOY_AXIS_TRIGGER_RIGHT: "\u2197", # rt
	},
	Type.NINTENDO: {
		JOY_AXIS_TRIGGER_LEFT: "\u219A", # zl
		JOY_AXIS_TRIGGER_RIGHT: "\u219B", # zr
	},
	Type.GENERIC: {
		JOY_AXIS_TRIGGER_LEFT: "\u24F6B", # 7
		JOY_AXIS_TRIGGER_RIGHT: "\u24FC", # 8
	},
}

var joypads: Dictionary
var active_joypad: Dictionary


func _ready() -> void:
	joypads = {}
	Input.joy_connection_changed.connect(_on_joypad_connected)


func get_joypad_type_string() -> String:
	if not joypads.is_empty():
		_set_active()
		return Type.keys()[active_joypad.type]
	return "NO_JOYPAD_CONNECTED"


func get_button_sign(button: JoyButton) -> String:
	if active_joypad:
		return BUTTON_MAPPING[active_joypad.type][button]
	return ""


func get_axis_sign(axis: JoyAxis) -> String:
	if active_joypad:
		return AXIS_MAPPING[active_joypad.type][axis]
	return ""


func get_button_icon(_button: JoyButton) -> Texture:
	return load("res://assets/joypad_glyphs/R2.svg")


func get_sign(input_event: InputEvent) -> String:
	if active_joypad:
		if input_event is InputEventJoypadButton:
			var joypad_button: InputEventJoypadButton = input_event as InputEventJoypadButton
			return BUTTON_MAPPING[active_joypad.type][joypad_button.button_index]
		elif input_event is InputEventJoypadMotion:
			var joypad_motion: InputEventJoypadMotion = input_event as InputEventJoypadMotion
			return AXIS_MAPPING[active_joypad.type][joypad_motion.axis]
	return ""


func _on_joypad_connected(device: int, connected: bool) -> void:
	_register_joypad(device, connected)
	joypad_changed.emit()


func _register_joypad(id: int, connected: bool) -> void:
	var info: Dictionary = Input.get_joy_info(id)
	if connected:
		# check if can and should be ignored
		if _should_be_ignored(info):
			return
		
		# register joypad
		joypads[id] = {
			"info": info,
			"type": _guess_type(info),
		}
		_set_active()
		print("joypad connected id: %d info: %s"%[id, info])
	else:
		print("joypad disconnected id %d"%id)
		_set_active()
		joypads.erase(id)


# _guess_type and _should_be_ignored currently supported only on Linux
# Windows support PR here https://github.com/godotengine/godot/pull/91539
func _guess_type(info: Dictionary) -> Type:
	if "raw_name" in info:
		var raw_name: String = info.raw_name
		raw_name = raw_name.to_lower()

		if "sony" in raw_name:
			return Type.PLAYSTATION
		if "microsoft" in raw_name:
			return Type.XBOX
		if "nintendo" in raw_name:
			return Type.NINTENDO
		if "steam" in raw_name:
			return Type.STEAM

	return Type.GENERIC


func _should_be_ignored(info: Dictionary) -> bool:
	if "vendor_id" in info and "product_id" in info:
		var ignore_device: bool = Input.should_ignore_device(info.vendor_id, info.product_id)
		if ignore_device:
			print("joypad ignored info: %s"%info)
			return true
	return false


func _set_active() -> void:
	if not joypads.is_empty():
		active_joypad = joypads.values()[0]
	else:
		active_joypad = {}
