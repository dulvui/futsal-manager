# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerListColumn
extends VBoxContainer

const ColorLabelScene: PackedScene = preload("res://src/ui_components/color_label/color_label.tscn")

signal sort


@onready var sort_button: Button = $SortButton

var color_labels: Array[ColorLabel] = []

var col_name: String

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func set_up(p_key:String, values: Array, p_col_name: String = "") -> void:
	col_name = p_col_name
	
	if p_key == "NAME":
		sort_button.text = p_key
	else:
		sort_button.text = p_key.substr(0,2)
	
	sort_button.tooltip_text = p_key
	
	for value: Variant in values:
		var label: ColorLabel = ColorLabelScene.instantiate()
		color_labels.append(label)
		add_child(label)
		label.tooltip_text = p_key
		label.set_up(p_key)
		label.set_value(value)
		if p_key == "NAME":
			label.enable_button()


func update_values(values: Array) -> void:
	for i: int in color_labels.size():
		if i < values.size():
			color_labels[i].show()
			color_labels[i].set_value(values[i])
		else:
			color_labels[i].hide()


func _on_sort_button_pressed() -> void:
	sort.emit()
