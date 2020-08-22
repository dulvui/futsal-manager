extends Control

signal player_select

var player = {}

func set_up_info(new_player):
	player = new_player
	$HBoxContainer/Name.text = player["name"] + " " + player["surname"]
	$DetailPopup/Info/Position.text = player["position"]
	$DetailPopup/Info/Age.text = player["birth_date"]
	$DetailPopup/Info/Nationality.text = player["nationality"]
	$DetailPopup/Info/Team.text = player["team"]
	
	var tech = player["stats"]["technial"]
	$DetailPopup/Technical/Cross.text = str(tech["crossing"])
	$DetailPopup/Technical/Pass.text = str(tech["pass"])
	$DetailPopup/Technical/LongPass.text = str(tech["long_pass"])
	$DetailPopup/Technical/Tackling.text = str(tech["tackling"])
	$DetailPopup/Technical/Corner.text = str(tech["corners"])
	
	var mental = player["stats"]["mental"]
	$DetailPopup/Mental/Agressivity.text = str(mental["agressivity"])
	$DetailPopup/Mental/Anticipation.text = str(mental["aniticipation"])
	$DetailPopup/Mental/Decisions.text = str(mental["decisions"])
	$DetailPopup/Mental/Concentration.text = str(mental["concentration"])
	$DetailPopup/Mental/Teamwork.text = str(mental["teamwork"])
	
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
