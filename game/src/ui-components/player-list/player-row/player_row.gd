# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name PlayerRow

signal info()

const ColorNumber = preload("res://src/ui-components/color-number/color_number.tscn")

@onready var name_label:Control = $HBoxContainer/NameLabel
@onready var position_label:Control = $HBoxContainer/PositionLabel
@onready var attributes:HBoxContainer = $HBoxContainer/Attributes


func set_up(player:Player, active_headers:Array[String]) -> void:
	for child in attributes.get_children():
		child.queue_free()
	
	name_label.set_text(player.surname)
	position_label.set_text(Player.Position.keys()[player.position])
	for key:String in Constants.ATTRIBUTES.keys():
		for attribute:String in Constants.ATTRIBUTES[key]:
			var color_number:ColorNumber = ColorNumber.instantiate()
			color_number.key = attribute
			color_number.set_up(player.attributes.get(key).get(attribute))
			color_number.visible = attribute in active_headers
			attributes.add_child(color_number)

func _on_button_button_down() -> void:
	info.emit()
