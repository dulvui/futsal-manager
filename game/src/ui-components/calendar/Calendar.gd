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
	var days = []
	for child in $GridContainer.get_children():
		child.queue_free()
	
	if current_month == 0:
		# to add mon tue
		for i in 2:
			var json = {
				"day" : 29 + i,
				"year" : 2019,
				"matches" : [],
				"trainings" : [],
				"week_day" : CalendarUtil.days[i] # + 2 because 1 jan 2020 is wensday
			}
			days.append(json)
		for day in DataSaver.calendar[current_month]:
			days.append(day)
	elif DataSaver.calendar[current_month][0]["week_day"] == "MON":
		days =  DataSaver.calendar[current_month]
	else:
		var index = DataSaver.calendar[current_month-1].size()
		for day in range(index - 1,index - 7, -1):
			days.append(DataSaver.calendar[current_month-1][day])
			if DataSaver.calendar[current_month-1][day]["week_day"] == "MON":
				break
		
		days.invert()
		for day in DataSaver.calendar[current_month]:
			days.append(day)
			
	# TODO check if days need to be added to fill table
				
	for day in days:
			var calendar_day = Day.instance()
			calendar_day.set_up(day, current_month == start_month and day["day"] == DataSaver.day)
			$GridContainer.add_child(calendar_day)
		
	$Paginator/Page.text = CalendarUtil.months[current_month]
	

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
