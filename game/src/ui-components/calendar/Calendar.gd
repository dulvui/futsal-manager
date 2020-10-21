extends Control

const Day = preload("res://src/ui-components/calendar/day/Day.tscn")


# get current month and show in paginator
# max back and forward is full current season

var current_month
var start_month

func _ready():
	current_month = DataSaver.month
	start_month = DataSaver.month
	set_up()

func set_up():
	for child in $GridContainer.get_children():
		child.queue_free()
	for day in DataSaver.calendar[current_month]:
		var calendar_day = Day.instance()
		calendar_day.set_up(day, current_month == start_month and day["day"] == DataSaver.day)
		$GridContainer.add_child(calendar_day)
		
		
	$Paginator/Page.text = str(current_month)
	

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


func _on_Prev_pressed():
	current_month -= 1
	if current_month < 0:
		current_month = 0
	set_up()
	
	

func _on_Next_pressed():
	current_month += 1
	if current_month > 11:
		current_month = 11
	set_up()
