extends Control

signal click

# day button of calendar

# on click emits signal, to show match or training popup in calendar
# if something set, else do nothing

func set_up(day, current_day):
	$Label.text = str(day["day"] + 1)
	var team_name
	if day["matches"].size() > 0:
		for matchz in day["matches"]:
			if matchz != null:
				if DataSaver.selected_team == matchz["home"]:
					team_name = matchz["away"]
				elif DataSaver.selected_team == matchz["away"]:
					team_name = matchz["home"]
					$ColorRect.color = Color.gray
		$Match.connect("pressed",self,"_on_Match_pressed",[day["matches"]])
		$Match.show()
		$Match.text = team_name
	if current_day:
		if $ColorRect.color != Color.gray:
			$ColorRect.color = Color.red
		else:
			$ColorRect.color = Color.lightpink
	
	$WeekDay.text = day["week_day"]


func _on_Match_pressed(matches):
	for child in $MatchPopup/VBoxContainer.get_children():
		child.queue_free()
		
	for matchz in matches:
		var label = Label.new()
		label.text = matchz["home"] + " : " + matchz["away"]
		label.align = Label.ALIGN_CENTER
		$MatchPopup/VBoxContainer.add_child(label)
	$MatchPopup.popup_centered()
