extends Control

signal player_select

const DetailNumber = preload("res://src/ui-components/color-number/ColorNumber.tscn")

var player = {}

func set_up_info(_player):
	player = _player

	$DetailPopup/TabContainer/Info/Info/Position.text = player["position"]
	$DetailPopup/TabContainer/Info/Info/Age.text = player["birth_date"]
	$DetailPopup/TabContainer/Info/Info/Nationality.text = player["nationality"]
	$DetailPopup/TabContainer/Info/Info/Team.text = str(player["prestige"])
	$DetailPopup/TabContainer/Info/Info/Foot.text = player["foot"]
	$DetailPopup/TabContainer/Info/Info/Nr.text = str(player["nr"])

	for key in player["attributes"]["mental"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Mental.add_child(label)
		var value = DetailNumber.instance()
		value.set_up(player["attributes"]["mental"][key])
		$DetailPopup/TabContainer/Info/Mental.add_child(value)

	for key in player["attributes"]["physical"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Fisical.add_child(label)
		var value = DetailNumber.instance()
		value.set_up(player["attributes"]["physical"][key])
		$DetailPopup/TabContainer/Info/Fisical.add_child(value)

	for key in player["attributes"]["technical"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Technical.add_child(label)
		var value = DetailNumber.instance()
		value.set_up(player["attributes"]["technical"][key])
		$DetailPopup/TabContainer/Info/Technical.add_child(value)

	$DetailPopup.popup_centered()

func _on_Hide_pressed():
	$DetailPopup.hide()
