# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerListRow
extends HBoxContainer

signal select

const color_number: PackedScene = preload("res://src/ui_components/color_number/color_number.tscn")

@onready var name_button: Button = $NameButton
@onready var position_label: Label = $PositionLabel
@onready var overall: ColorNumber = $Overall
@onready var mental: HBoxContainer = $Mental
@onready var technical: HBoxContainer = $Technical
@onready var physical: HBoxContainer = $Physical
@onready var goalkeeper: HBoxContainer = $Goalkeeper


func _ready() -> void:
	for mental_value: String in Const.ATTRIBUTES["mental"]:
		var number: ColorNumber = color_number.instantiate()
		number.set_up(mental_value)
		mental.add_child(number)

	for technical_value: String in Const.ATTRIBUTES["technical"]:
		var number: ColorNumber = color_number.instantiate()
		number.set_up(technical_value)
		technical.add_child(number)

	for physical_value: String in Const.ATTRIBUTES["physical"]:
		var number: ColorNumber = color_number.instantiate()
		number.set_up(physical_value)
		physical.add_child(number)
		
	for goalkeeper_value: String in Const.ATTRIBUTES["goalkeeper"]:
		var number: ColorNumber = color_number.instantiate()
		number.set_up(goalkeeper_value)
		goalkeeper.add_child(number)


func set_player(player: Player) -> void:
	name_button.tooltip_text = tr("Click for info of") + " " + player.surname

	position_label.set_text(Player.Position.keys()[player.position])
	name_button.set_text(player.surname)

	overall.set_value(player.get_overall())
	
	for row in mental.get_children() as Array[ColorNumber]:
		row.set_value(player.attributes.mental.get(row.value_name))
	
	for row in physical.get_children() as Array[ColorNumber]:
		row.set_value(player.attributes.physical.get(row.value_name))

	for row in technical.get_children() as Array[ColorNumber]:
		row.set_value(player.attributes.technical.get(row.value_name))
	
	for row in goalkeeper.get_children() as Array[ColorNumber]:
		row.set_value(player.attributes.goalkeeper.get(row.value_name))


func _on_name_button_pressed() -> void:
	select.emit()
