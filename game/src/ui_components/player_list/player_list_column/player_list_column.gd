# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerListColumn
extends VBoxContainer

const ColorLabelScene: PackedScene = preload("res://src/ui_components/color_label/color_label.tscn")

signal sort(key: String)

@onready var sort_button: Button = $SortButton

var key: String
var color_labels: Array[ColorLabel]

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func set_up(p_key:String, values: Array) -> void:
	key = p_key
	sort_button.text = key.substr(0,3)
	
	for value: Variant in values:
		var label: ColorLabel = ColorLabelScene.instantiate()
		color_labels.append(label)
		add_child(label)
		label.set_up(key)
		label.set_value(value)


func update_values(values: Array) -> void:
	for i: int in color_labels.size():
		if i < values.size():
			color_labels[i].show()
			color_labels[i].set_value(values[i])
		else:
			color_labels[i].hide()


func _on_sort_button_pressed() -> void:
	sort.emit(key)
