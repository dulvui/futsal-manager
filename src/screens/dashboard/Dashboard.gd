extends Control


func _ready():
	$ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$TeamName.text = DataSaver.team["name"]

	for day in CalendarUtil.calendar:
		var day_label = Label.new()
		if day["matches"].size() > 0:
			day_label.text = str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + day["matches"][0]["home"] + " vs " + day["matches"][0]["away"]
		else:
			day_label.text = str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + " no match"
		$Calendar/List.add_child(day_label)
