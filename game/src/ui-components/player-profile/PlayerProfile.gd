extends Control

signal player_select

const DetailNumber = preload("res://src/ui-components/color-number/ColorNumber.tscn")

var player = {}

func set_up_info(_player,info_type):
	player = _player
	
	$Info/Name.text = player["name"].substr(0,1) + ". " + player["surname"]
	$Info/General/Position.text = player["position"]
	$Info/General/Prestige.text = str(player["prestige"])
	
	
	# TODO create profile for goalpkeeper
	# AND make labels dynamic by keys
	
	if player["position"] != "G":
		for key in player["attributes"]["mental"].keys():
#			var label = Label.new()
#			label.text = tr(key.to_upper())
#			$Info/Mental.add_child(label)
			var value = DetailNumber.instance()
			value.set_up(player["attributes"]["mental"][key])
			$Info/Mental.add_child(value)

		for key in player["attributes"]["physical"].keys():
#			var label = Label.new()
#			label.text = tr(key.to_upper())
#			$Info/Fisical.add_child(label)
			var value = DetailNumber.instance()
			value.set_up(player["attributes"]["physical"][key])
			$Info/Fisical.add_child(value)

		match info_type:
			"GENERAL":
				$Info/General.show()
			"MENTAL":
				$Info/Mental.show()
			"FISICAL":
				$Info/Fisical.show()

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



func _on_Details_pressed():
	$DetailPopup.popup_centered()


func _on_Select_pressed():
	emit_signal("player_select")


func _on_Hide_pressed():
	$DetailPopup.hide()
