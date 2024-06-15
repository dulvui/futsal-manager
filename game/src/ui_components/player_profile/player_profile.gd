# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerProfile
extends VBoxContainer

signal select(player: Player)
signal cancel

const ColorLabelScene: PackedScene = preload("res://src/ui_components/color_label/color_label.tscn")

var player: Player

@onready var info: Control = $Info
@onready var attributes: Control = $Attributes

@onready var player_name: Label = $Info/Name
@onready var pos: Label = $Info/Position
@onready var age: Label = $Info/Age
@onready var foot: Label = $Info/Foot
@onready var nationality: Label = $Info/Nationality
@onready var team: Label = $Info/Team
@onready var nr: Label = $Info/Nr
@onready var attributes_average: Label = $Info/AttributesAverage
@onready var prestige: Label = $Info/Prestige
@onready var price: Label = $Info/Price
@onready var goals: Label = $History/Goals


func set_player(_player: Player) -> void:
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
	attributes_average.text = str(player.get_overall())
	prestige.text = str(player.prestige)
	price.text = CurrencyUtil.get_sign(player.price)


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
			var value: ColorLabel = ColorLabelScene.instantiate()
			attributes.get_node(attribute.capitalize()).add_child(value)
			value.set_up(key)
			value.set_value(player.get_value(attribute,key))

	#history
	goals.text = str(player.statistics[Config.current_season].goals)


func _on_select_pressed() -> void:
	select.emit(player)


func _on_close_pressed() -> void:
	cancel.emit()
