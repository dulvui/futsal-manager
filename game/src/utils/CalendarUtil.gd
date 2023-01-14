extends Node

const MONTHS:Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
const DAYS:Array = ["MON","TUE","WE","THU","FRI","SAT","SUN"]
const DAY_IN_SECONDS:int = 86400

var date:Dictionary




func _ready() -> void:
	date = DataSaver.date
	
func initial_date() -> Dictionary:
	date = OS.get_date()
	
	# set month to 1st of june
	date.day = 1
	date.month = 6
	return date

func create_calendar() -> void:
	
	var calendar:Array = []
	
	var temp_date:Dictionary = date.duplicate(true)
	
	# set month to 1st of june
	temp_date.day = 1
	temp_date.month = 6
	
	
	# create months
	for i in range(0,12):
		calendar.append([])
	
	# create days
	for i in 365: #chek if year has really 365 days
		var day:Dictionary = {
			"matches" : [],
			"trainings" : [],
			"weekday" : DAYS[temp_date.weekday - 1]
		}
		calendar[temp_date.month - 1].append(day)
		
		temp_date = _get_next_day(temp_date)
		
	DataSaver.save_calendar(calendar)

func next_day() -> void:
	date = _get_next_day(date)
	DataSaver.date = date
	
	
	# get email for next match
	var next_match_month:int = date.month
	var next_match_day:int = date.day
	
	# if next match is the first of the next month
	if date.day == DataSaver.calendar[date.month].size() - 1 and DataSaver.calendar[date.month + 1 ][0]["matches"].size() > 0:
		next_match_month = date.month + 1
		next_match_day = 0
	
	var next_match:Dictionary
	if next_match_day < DataSaver.calendar[next_match_month].size():
		for matchz in DataSaver.calendar[next_match_month][next_match_day]["matches"]:
			if matchz["home"] == DataSaver.team_name or matchz["away"] == DataSaver.team_name:
				next_match = matchz
	
	if next_match:
		EmailUtil.message(next_match,EmailUtil.MESSAGE_TYPES.NEXT_MATCH)



func get_dashborad_date() -> String:
	return DAYS[date.weekday - 1] + " " + str(date.day) + " " + MONTHS[date.month] + " " + str(date.year)

func get_next_match() -> Dictionary:
	for matchz in DataSaver.calendar[DataSaver.date.month][DataSaver.date.day - 1]["matches"]:
		if matchz["home"] == DataSaver.team_name or matchz["away"] == DataSaver.team_name:
			return matchz
	return {}


func _get_next_day(_date:Dictionary) -> Dictionary:
	var unix_time:int = OS.get_unix_time_from_datetime(_date)
	unix_time += DAY_IN_SECONDS
	var next_day:Dictionary = OS.get_datetime_from_unix_time(unix_time)
	next_day.erase("hour")
	next_day.erase("minute")
	next_day.erase("second")
	
	return next_day
