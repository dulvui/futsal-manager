extends Control


func set_up_info(player):
	print(player)
	$Name.text = player["name"] + " " + player["surname"]
	$Info/Position.text = player["position"]
	$Info/Age.text = player["birth_date"]
	$Info/Nationality.text = player["nationality"]
	$Info/Team.text = player["team"]
	
	var tech = player["stats"]["technial"]
	$Technical/Cross.text = str(tech["crossing"])
	$Technical/Pass.text = str(tech["pass"])
	$Technical/LongPass.text = str(tech["long_pass"])
	$Technical/Tackling.text = str(tech["tackling"])
	$Technical/Corner.text = str(tech["corners"])
	
	var mental = player["stats"]["mental"]
	$Mental/Agressivity.text = str(mental["agressivity"])
	$Mental/Anticipation.text = str(mental["aniticipation"])
	$Mental/Decisions.text = str(mental["decisions"])
	$Mental/Concentration.text = str(mental["concentration"])
	$Mental/Teamwork.text = str(mental["teamwork"])
	
	# paint stats numbers
	for child in self.get_children():
		for child_child in child.get_children():
			if child_child is Label and child_child.text.is_valid_integer():
				if int(child_child.text) < 11 :
					child_child.add_color_override("font_color", Color.red)
				elif int(child_child.text) < 16:
					child_child.add_color_override("font_color", Color.blue)
				else:
					child_child.add_color_override("font_color", Color.green)
					
