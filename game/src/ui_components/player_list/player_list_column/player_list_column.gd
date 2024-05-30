# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerListColumn
extends VBoxContainer

const ColorLabelScene: PackedScene = preload("res://src/ui_components/color_label/color_label.tscn")

signal sort(key: String)

@export var key: String

@onready var sort_button: Button = $SortButton


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func set_up(p_key:String, values: Array) -> void:
	key = p_key
	sort_button.text = key.substr(0,3)
	
	for value:int in values:
		var label: ColorLabel = ColorLabelScene.instantiate()
		add_child(label)
		label.set_up(key)
		label.set_value(value)


func _on_sort_button_pressed() -> void:
	sort.emit(key)
