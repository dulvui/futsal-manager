extends Control

const Day = preload("res://src/ui-components/calendar/day/Day.tscn")


# get current month and show in paginator
# max back and forward is full current season

var current_month

func _ready():
	set_up()

func set_up():
	current_month = DataSaver.month
	for child in $GridContainer.get_children():
		child.queue_free()
	for day in DataSaver.calendar[current_month]:
		var calendar_day = Day.instance()
		calendar_day.set_up(day, day["day"] == DataSaver.day)
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
