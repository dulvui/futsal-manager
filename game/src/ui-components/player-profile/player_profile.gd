# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal select(player:Player)

const DetailNumber:PackedScene = preload("res://src/ui-components/color-number/color_number.tscn")

var player:Player

@onready var info:Control = $TabContainer/Info
@onready var attributes:Control = $TabContainer/Attributes


func set_up_info(_player:Player) -> void:
	player = _player
	
	$TabContainer/Info/Info/Name.text = player.name + " " + player.surname
	$TabContainer/Info/Info/Position.text = str(player.position)
	$TabContainer/Info/Info/Age.text = str(player.birth_date.day) + "/" + str(player.birth_date.month) + "/" + str(player.birth_date.year)
	$TabContainer/Info/Info/Nationality.text = player.nationality
	$TabContainer/Info/Info/Team.text = str(player.team)
	$TabContainer/Info/Info/Foot.text = str(player.foot)
	$TabContainer/Info/Info/Nr.text = str(player.nr)
	
	# attributes
	for attribute:String in Constants.ATTRIBUTES.keys():
		# first remove existing values
		for child:Node in attributes.get_node(attribute.capitalize()).get_children():
			child.queue_free()
		
		# add title and a empty label
		var label_title:Label = Label.new()
		label_title.text = tr(attribute.to_upper())
		attributes.get_node(attribute.capitalize()).add_child(label_title)
		attributes.get_node(attribute.capitalize()).add_child(Label.new())
		
		for key:String in Constants.ATTRIBUTES[attribute]:
			var label:Label = Label.new()
			label.text = tr(key.to_upper())
			label.tooltip_text = tr(key.to_upper())
			#label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			attributes.get_node(attribute.capitalize()).add_child(label)
			var value:Control = DetailNumber.instantiate()
			value.set_up(player.attributes.get(attribute).get(key))
			attributes.get_node(attribute.capitalize()).add_child(value)
		
	#history
	$TabContainer/History/Actual/Goals.text = str(player.statistics[Config.current_season].goals)

	show()

func _on_select_pressed() -> void:
	select.emit(player)

func _on_close_pressed() -> void:
	hide()

