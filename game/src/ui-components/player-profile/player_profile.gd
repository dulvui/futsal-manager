# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const DetailNumber:PackedScene = preload("res://src/ui-components/color-number/color_number.tscn")

var player:Player

@onready
var info:Control = $TabContainer/Info

func set_up_info(_player:Player) -> void:
	player = _player
	
	$TabContainer/Info/Info/Name.text = player.surname + " " + player.name
	$TabContainer/Info/Info/Position.text = str(player.position)
	$TabContainer/Info/Info/Age.text = str(player.birth_date.day) + "/" + str(player.birth_date.month) + "/" + str(player.birth_date.year)
	$TabContainer/Info/Info/Nationality.text = player.nationality
#	$TabContainer/Info/Info/Team.text = str(player.team_name)
	$TabContainer/Info/Info/Foot.text = str(player.foot)
	$TabContainer/Info/Info/Nr.text = str(player.nr)

	for attribute:String in Constants.ATTRIBUTES.keys():
		for key:String in Constants.ATTRIBUTES[attribute]:
			var label:Label = Label.new()
			label.text = tr(key.to_upper())
			info.get_node(attribute.capitalize()).add_child(label)
			var value:Control = DetailNumber.instantiate()
			value.set_up(player.attributes.get(attribute).get(key))
			info.get_node(attribute.capitalize()).add_child(value)
		
	#history
	$TabContainer/History/Actual/Goals.text = str(player.statistics[-1].goals)

	show()

func _on_Hide_pressed() -> void:
	hide()
