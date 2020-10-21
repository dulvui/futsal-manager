extends Control

const Day = preload("res://src/ui-components/calendar/day/Day.tscn")


# get current month and show in paginator
# max back and forward is full current season

var current_month = DataSaver.month

func _ready():
	for day in DataSaver.calendar[current_month]:
#		var day_label = Label.new()
#		if day["matches"].size() > 0:
#			day_label.text = get_text(day)
#		else:
#			day_label.text = str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + " no match"
#
#		var button = Button.new()
#		button.text = tr('ALL_GAMES')
#
#		button.connect("pressed",self,"show_all_matches",[day])
		
		var calendar_day = Day.instance()
		calendar_day.set_up(day)
		$GridContainer.add_child(calendar_day)
		
func get_text(day):
	for matchz in day["matches"]:
		if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
			return str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + matchz["home"] + " vs " + matchz["away"]

func show_all_matches(day):
	for child in $MatchDayPopUp/VBoxContainer.get_children():
		child.queue_free()
	for matchz in day["matches"]:
		var label = Label.new()
		label.text = matchz["home"] + " vs " + matchz["away"]
		$MatchDayPopUp/VBoxContainer.add_child(label)
	$MatchDayPopUp.popup_centered()
	


func _on_Close_pressed():
	hide()
