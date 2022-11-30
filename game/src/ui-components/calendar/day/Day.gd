extends Control

signal click

# day button of calendar

# on click emits signal, to show match or training popup in calendar
# if something set, else do nothing

func set_up(day, current_day, current_month) -> void:
	$Label.text = str(current_day + 1)
	var team_name
	if day["matches"].size() > 0:
		for matchz in day["matches"]:
			if matchz != null:
				if DataSaver.team_name == matchz["home"]:
					team_name = matchz["away"]
				elif DataSaver.team_name == matchz["away"]:
					team_name = matchz["home"]
					$ColorRect.color = Color.gray
		$Match.connect("pressed",self,"_on_Match_pressed",[day["matches"]])
		$Match.show()
		$Match.text = team_name
	if current_day + 1 == DataSaver.date.day and DataSaver.date.month == current_month:
		if $ColorRect.color != Color.gray:
			$ColorRect.color = Color.red
		else:
			$ColorRect.color = Color.lightpink
			
	
	$WeekDay.text = day["weekday"]


func _on_Match_pressed(matches) -> void:
	for child in $MatchPopup/VBoxContainer.get_children():
		child.queue_free()
		
	for matchz in matches:
		var label = Label.new()
		print(matchz)
		label.text = matchz["home"] + " " + matchz["result"] + " " + matchz["away"]
		label.align = Label.ALIGN_CENTER
		$MatchPopup/VBoxContainer.add_child(label)
	$MatchPopup.popup_centered()


func _on_Close_pressed() -> void:
	$MatchPopup.hide()
