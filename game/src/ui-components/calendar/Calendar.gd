extends ScrollContainer


func _ready():
	for day in DataSaver.calendar:
		print(day)
		var day_label = Label.new()
		if day["matches"].size() > 0:
			day_label.text = get_text(day)
		else:
			day_label.text = str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + " no match"
		$List.add_child(day_label)
		
func get_text(day):
	for matchz in day["matches"]:
		if matchz["home"] == DataSaver.team["name"] or matchz["away"] == DataSaver.team["name"]:
			return str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + matchz["home"] + " vs " + matchz["away"]
