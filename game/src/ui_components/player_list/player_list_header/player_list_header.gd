# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerListHeader
extends HBoxContainer

signal sort(key: String, value: String)

const color_number: PackedScene = preload("res://src/ui_components/color_number/color_number.tscn")

@onready var position_button: Button = $PositionButton
@onready var overall_button: Button = $OverallButton
@onready var name_button: Button = $NameButton

@onready var mental: HBoxContainer = $Mental
@onready var technical: HBoxContainer = $Technical
@onready var physical: HBoxContainer = $Physical
@onready var goalkeeper: HBoxContainer = $Goalkeeper


func _ready() -> void:
	for value: String in Const.ATTRIBUTES["mental"]:
		var button: Button = Button.new()
		button.text = value.substr(0, 2)
		button.pressed.connect(_on_button_pressed.bind("mental", value))
		mental.add_child(button)
	
	for value: String in Const.ATTRIBUTES["technical"]:
		var button: Button = Button.new()
		button.text = value.substr(0, 1)
		button.pressed.connect(_on_button_pressed.bind("technical", value))
		technical.add_child(button)
	
	for value: String in Const.ATTRIBUTES["physical"]:
		var button: Button = Button.new()
		button.text = value.substr(0, 2)
		button.pressed.connect(_on_button_pressed.bind("physical", value))
		physical.add_child(button)
	
	for value: String in Const.ATTRIBUTES["goalkeeper"]:
		var button: Button = Button.new()
		button.text = value.substr(0, 2)
		button.pressed.connect(_on_button_pressed.bind("goalkeeper", value))
		goalkeeper.add_child(button)

func _on_button_pressed(key: String, value: String)-> void:
	sort.emit(key, value)
