extends Control


func _ready():
	for day in DataSaver.calendar:
		var day_label = Label.new()
		if day["matches"].size() > 0:
			day_label.text = get_text(day)
		else:
			day_label.text = str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + " no match"
		
		var button = Button.new()
		button.text = tr('ALL_GAMES')
		
		button.connect("pressed",self,"show_all_matches",[day])
		
		$ScrollContainer/List.add_child(day_label)
		$ScrollContainer/List.add_child(button)
		
func get_text(day):
	for matchz in day["matches"]:
		if matchz["home"] == DataSaver.team["name"] or matchz["away"] == DataSaver.team["name"]:
			return str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + matchz["home"] + " vs " + matchz["away"]

func show_all_matches(day):
	print(day)
	for matchz in day["matches"]:
		var label = Label.new()
		label.text = matchz["home"] + " vs " + matchz["away"]
		$MatchDayPopUp/VBoxContainer.add_child(label)
	$MatchDayPopUp.popup_centered()
	
