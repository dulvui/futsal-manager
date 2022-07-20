extends Node

const MONTHS = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
const DAYS = ["MON","TUE","WE","THU","FRI","SAT","SUN"]
const DAY_IN_SECONDS = 86400

var date




func _ready():
	date = DataSaver.date

func create_calendar():
	
	date = OS.get_date()
	
	var calendar = []
	
	var temp_date = date.duplicate(true)
	
	# set month to 1st
	temp_date.day = 1
	
	# create months
	for i in range(0,12):
		calendar.append([])
	
	# create days
	for i in 365: #chek if year has really 365 days
		var day = {
			"matches" : [],
			"trainings" : [],
			"weekday" : DAYS[temp_date.weekday - 1]
		}
		calendar[temp_date.month - 1].append(day)
		
		temp_date = _get_next_day(temp_date)
		
	DataSaver.save_calendar(calendar)

func next_day():
	date = _get_next_day(date)
	DataSaver.date = date
	
#	MatchMaker.check_date(day,month,year)
	# check contracts
	# generate random news/ emails
	# check trainings
	# player growth
	# pay players/staff
	
	# check month bounds
#	var next_dayz
#	var next_monthz
#	if date.day > DataSaver.calendar[date.month].size() :
#		next_dayz = 0
#		next_monthz = DataSaver.month + 1 #TODO check months bounds
#	else:
#		next_dayz = date.day + 1
#		next_monthz = date.month
	
	if DataSaver.calendar[date.month][date.day - 1]["matches"].size() > 0:
		var next_match
		for matchz in DataSaver.calendar[date.month][date.day - 1]["matches"]:
			if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
				next_match = matchz
		EmailUtil.message(next_match,EmailUtil.MESSAGE_TYPES.NEXT_MATCH)



func get_date():
	return DAYS[date.weekday - 1] + " " + str(date.day) + " " + MONTHS[date.month - 1] + " " + str(date.year)

func get_next_match():
	for matchz in DataSaver.calendar[DataSaver.date.month][DataSaver.date.day - 1]["matches"]:
		if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
			return matchz


func _get_next_day(date):
	var unix_time = OS.get_unix_time_from_datetime(date)
	unix_time += DAY_IN_SECONDS
	var next_day = OS.get_datetime_from_unix_time(unix_time)
	next_day.erase("hour")
	next_day.erase("minute")
	next_day.erase("second")
	
	return next_day
