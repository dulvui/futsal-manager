extends Control

signal player_select

const DetailNumber = preload("res://src/ui-components/color-number/ColorNumber.tscn")

var player = {}

func set_up_info(_player) -> void:
	player = _player
	
	$DetailPopup/TabContainer/Info/Info/Name.text = player["surname"] + " " + player["name"]
	$DetailPopup/TabContainer/Info/Info/Position.text = player["position"]
	$DetailPopup/TabContainer/Info/Info/Age.text = player["birth_date"]
	$DetailPopup/TabContainer/Info/Info/Nationality.text = player["nationality"]
	$DetailPopup/TabContainer/Info/Info/Team.text = str(player["team"])
	$DetailPopup/TabContainer/Info/Info/Foot.text = player["foot"]
	$DetailPopup/TabContainer/Info/Info/Nr.text = str(player["nr"])

	for key in player["attributes"]["mental"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Mental.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["mental"][key])
		$DetailPopup/TabContainer/Info/Mental.add_child(value)

	for key in player["attributes"]["physical"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Fisical.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["physical"][key])
		$DetailPopup/TabContainer/Info/Fisical.add_child(value)

	for key in player["attributes"]["technical"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Technical.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["technical"][key])
		$DetailPopup/TabContainer/Info/Technical.add_child(value)
		
	for key in player["attributes"]["goalkeeper"].keys():
		var label = Label.new()
		label.text = tr(key.to_upper())
		$DetailPopup/TabContainer/Info/Goalkeeper.add_child(label)
		var value = DetailNumber.instantiate()
		value.set_up(player["attributes"]["goalkeeper"][key])
		$DetailPopup/TabContainer/Info/Goalkeeper.add_child(value)
		
	#history
	$DetailPopup/TabContainer/History/Actual/Goals.text = str(player["history"][DataSaver.current_season]["actual"]["goals"])

	$DetailPopup.popup_centered()

func _on_Hide_pressed() -> void:
	$DetailPopup.hide()

func _on_DetailPopup_hide() -> void:
	queue_free()
