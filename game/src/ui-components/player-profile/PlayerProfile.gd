extends Control

signal player_select

var player = {}

func set_up_info(new_player):
	player = new_player
	$HBoxContainer/Name.text = player["name"].substr(0,1) + ". " + player["surname"]
	$DetailPopup/Info/Position.text = player["position"]
	$HBoxContainer/Position.text = player["position"]
	$DetailPopup/Info/Age.text = player["birth_date"]
	$DetailPopup/Info/Nationality.text = player["nationality"]
	$DetailPopup/Info/Team.text = str(player["prestige"])
	$HBoxContainer/Prestige.text = str(player["prestige"])
	
	for key in player["mental"].keys():
		var ui = $DetailPopup/Mental.get_node(key)
		ui.text = str(player["mental"][key])

	for key in player["fisical"].keys():
		var ui = $DetailPopup/Fisical.get_node(key)
		ui.text = str(player["fisical"][key])
		
	for key in player["technical"].keys():
		var ui = $DetailPopup/Technical.get_node(key)
		ui.text = str(player["technical"][key])
	
	# paint stats numbers
	for child in $DetailPopup.get_children():
		for child_child in child.get_children():
			if child_child is Label and child_child.text.is_valid_integer():
				if int(child_child.text) < 11 :
					child_child.add_color_override("font_color", Color.red)
				elif int(child_child.text) < 16:
					child_child.add_color_override("font_color", Color.blue)
				else:
					child_child.add_color_override("font_color", Color.green)
					


func _on_Details_pressed():
	$DetailPopup.popup_centered()


func _on_Select_pressed():
	print("select in prfoile")
	emit_signal("player_select")


func _on_Hide_pressed():
	$DetailPopup.hide()
