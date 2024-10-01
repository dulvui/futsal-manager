# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SwitchOptionButton
extends MarginContainer

signal item_selected(index: int)

@onready var option_button: OptionButton = $HBoxContainer/OptionButton


func set_up(items: Array, selected: int = 0) -> void:
	for item: String in items:
		option_button.add_item(item)
	option_button.selected = selected


func _on_next_pressed() -> void:
	if option_button.selected > 0:
		option_button.selected -= 1
	else:
		option_button.selected = option_button.item_count - 1
	item_selected.emit(option_button.selected)


func _on_prev_pressed() -> void:
	if option_button.selected < option_button.item_count - 1:
		option_button.selected += 1
	else:
		option_button.selected = 0
	item_selected.emit(option_button.selected)


func _on_option_button_item_selected(index: int) -> void:
	item_selected.emit(index)
