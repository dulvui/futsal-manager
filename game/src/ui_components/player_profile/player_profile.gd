# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerProfile
extends Control

signal select(player: Player)

const DetailNumber: PackedScene = preload("res://src/ui_components/color_number/color_number.tscn")

var player: Player

@onready var info: Control = $TabContainer/Info
@onready var attributes: Control = $TabContainer/Attributes

@onready var player_name: Label = $TabContainer/Info/Info/Name
@onready var pos: Label = $TabContainer/Info/Info/Position
@onready var age: Label = $TabContainer/Info/Info/Age
@onready var foot: Label = $TabContainer/Info/Info/Foot
@onready var nationality: Label = $TabContainer/Info/Info/Nationality
@onready var team: Label = $TabContainer/Info/Info/Team
@onready var nr: Label = $TabContainer/Info/Info/Nr
@onready var attributes_average: Label = $TabContainer/Info/Info/AttributesAverage
@onready var prestige: Label = $TabContainer/Info/Info/Prestige
@onready var goals: Label = $TabContainer/History/Actual/Goals


func set_up_info(_player: Player) -> void:
	player = _player

	player_name.text = player.name + " " + player.surname
	pos.text = str(player.position)
	age.text = (
		str(player.birth_date.day)
		+ "/"
		+ str(player.birth_date.month)
		+ "/"
		+ str(player.birth_date.year)
	)
	foot.text = tr(Const.Nations.keys()[player.nation])
	nationality.text = str(player.team)
	team.text = str(player.foot)
	nr.text = str(player.nr)
	attributes_average.text = str(player.get_attributes_average())
	prestige.text = str(player.prestige)

	# attributes
	for attribute: String in Const.ATTRIBUTES.keys():
		# first remove existing values
		for child: Node in attributes.get_node(attribute.capitalize()).get_children():
			child.queue_free()

		# add title and a empty label
		var label_title: Label = Label.new()
		label_title.text = tr(attribute.to_upper())
		attributes.get_node(attribute.capitalize()).add_child(label_title)
		attributes.get_node(attribute.capitalize()).add_child(Label.new())

		for key: String in Const.ATTRIBUTES[attribute]:
			var label: Label = Label.new()
			label.text = tr(key.to_upper())
			label.tooltip_text = tr(key.to_upper())
			#label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			attributes.get_node(attribute.capitalize()).add_child(label)
			var value: ColorNumber = DetailNumber.instantiate()
			value.set_up((player.attributes.get(attribute) as Resource).get(key))
			attributes.get_node(attribute.capitalize()).add_child(value)

	#history
	goals.text = str(player.statistics[Config.current_season].goals)

	show()


func _on_select_pressed() -> void:
	select.emit(player)


func _on_close_pressed() -> void:
	hide()
