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
		$Match.text = team_name
	if current_day:
		if $ColorRect.color != Color.gray:
			$ColorRect.color = Color.red
		else:
			$ColorRect.color = Color.lightpink
