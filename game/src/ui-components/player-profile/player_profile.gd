# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const DetailNumber:PackedScene = preload("res://src/ui-components/color-number/color_number.tscn")

var player:Dictionary = {}

func set_up_info(_player:Dictionary) -> void:
	player = _player
	
	$TabContainer/Info/Info/Name.text = player["surname"] + " " + player["name"]
	$TabContainer/Info/Info/Position.text = player["position"]
	$TabContainer/Info/Info/Age.text = player["birth_date"]
	$TabContainer/Info/Info/Nationality.text = player["nationality"]
	$TabContainer/Info/Info/Team.text = str(player["team"])
	$TabContainer/Info/Info/Foot.text = player["foot"]
	$TabContainer/Info/Info/Nr.text = str(player["nr"])

	for key in player["attributes"]["mental"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$TabContainer/Info/Mental.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["mental"][key])
		$TabContainer/Info/Mental.add_child(value)

	for key in player["attributes"]["physical"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$TabContainer/Info/Fisical.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["physical"][key])
		$TabContainer/Info/Fisical.add_child(value)

	for key in player["attributes"]["technical"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$TabContainer/Info/Technical.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["technical"][key])
		$TabContainer/Info/Technical.add_child(value)
		
	for key in player["attributes"]["goalkeeper"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$TabContainer/Info/Goalkeeper.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["goalkeeper"][key])
		$TabContainer/Info/Goalkeeper.add_child(value)
		
	#history
	$TabContainer/History/Actual/Goals.text = str(player["history"][Config.current_season]["actual"]["goals"])

	show()

func _on_Hide_pressed() -> void:
	hide()
