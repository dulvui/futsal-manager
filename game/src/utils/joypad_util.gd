# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Type {
	PS,
	XBOX,
	NINTENDO,
	STEAM,
	GENERIC,
}


var joypads: Dictionary


func _ready() -> void:
	joypads = {}
	Input.joy_connection_changed.connect(_on_joypad_connected)


func _on_joypad_connected(device: int, connected: bool) -> void:
	_register_joypad(device, connected)


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
		print("joypad connected id: %d info: %s"%[id, info])
	else:
		print("joypad disconnected id %d"%id)
		joypads.erase(id)


# _guess_type and _should_be_ignored currently supported only on Linux
# Windows support PR here https://github.com/godotengine/godot/pull/91539
func _guess_type(info: Dictionary) -> Type:
	if "raw_name" in info:
		var raw_name: String = info.raw_name
		raw_name = raw_name.to_lower()

		if "sony" in raw_name:
			return Type.PS
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
