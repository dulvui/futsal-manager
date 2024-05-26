# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerListRow
extends Control

signal info

# player row button colors
const COLOR_FOCUS: Color = Color(1, 1, 1, 0.2)
const COLOR_NORMAL: Color = Color(1, 1, 1, 0)

const color_number: PackedScene = preload("res://src/ui_components/color_number/color_number.tscn")

@onready var button: Button = $Button
@onready var name_label: Label = $NameLabel
@onready var position_label: Label = $PositionLabel
@onready var attributes_average: ColorNumber = $AttributesAverage
@onready var attributes: HBoxContainer = $Attributes


func set_up(player: Player) -> void:
	button.tooltip_text = tr("Click for info of") + " " + player.surname

	position_label.set_text(Player.Position.keys()[player.position])
	name_label.set_text(player.surname)

	attributes_average.set_up(player.get_attributes_average())

	for key: String in Const.ATTRIBUTES.keys():
		for attribute: String in Const.ATTRIBUTES[key]:
			var number: ColorNumber = color_number.instantiate()
			attributes.add_child(number)
			number.key = attribute
			number.set_up((player.attributes.get(key) as Resource).get(attribute))


func _on_button_button_down() -> void:
	info.emit()


func _on_button_mouse_entered() -> void:
	button.self_modulate = COLOR_FOCUS


func _on_button_mouse_exited() -> void:
	button.self_modulate = COLOR_NORMAL
