extends Control

const Day = preload("res://src/ui-components/calendar/day/Day.tscn")


# get current month and show in paginator
# max back and forward is full current season

var current_month

func _ready():
	current_month = DataSaver.date.month - 1
	set_up()

func set_up():
	# clean grid container
	for child in $GridContainer.get_children():
		child.queue_free()
	
	
	for i in range(0, DataSaver.calendar[current_month].size()):
		var calendar_day = Day.instance()
		calendar_day.set_up(DataSaver.calendar[current_month][i], i)
		$GridContainer.add_child(calendar_day)
#
	$Paginator/Page.text = CalendarUtil.MONTHS[current_month - 1]
	

func get_text(day):
	for matchz in day["matches"]:
		if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
			return str(day["day"]) + "/" + str(day["month"]) + "/" + str(day["year"]) + matchz["home"] + " vs " + matchz["away"]


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
