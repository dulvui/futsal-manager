extends Node

var months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
var days = ["MON","TUE","WE","THU","FRI","SAT","SUN"]

var date

const DAY_IN_SECONDS = 86400


func _ready():
	
	date = DataSaver.date
	print("datasvaer date " + str(date))
	
	print("calendar util " + get_date())
	
	_get_next_day_date(date)

func create_calendar():
	
	
	var calendar = []
	
	var temp_date = date
	
	# create months
	for i in range(0,12):
		calendar.append([])
	
	for i in 366: #3020?
		var json = {
			"day" : temp_date.day,
			"year" : temp_date.year,
			"matches" : [],
			"trainings" : [],
			"week_day" : days[temp_date.weekday] # + 2 because 1 jan 2020 is wensday
		}
		calendar[temp_date.month - 1].append(json)
		
		temp_date = _get_next_day_date(temp_date)

	DataSaver.save_calendar(calendar)

func next_day():
	date = _get_next_day_date(date)
	
#	MatchMaker.check_date(day,month,year)
	# check contracts
	# generate random news/ emails
	# check trainings
	# player growth
	# pay players/staff
	
	# check month bounds
	var next_dayz
	var next_monthz
	if date.day >= DataSaver.calendar[date.month].size() - 1:
		next_dayz = 0
		next_monthz = DataSaver.month + 1 #TODO check months bounds
	else:
		next_dayz = date.day + 1
		next_monthz = date.month
	
	if DataSaver.calendar[next_monthz][next_dayz]["matches"].size() > 0:
		var next_match
		for matchz in DataSaver.calendar[next_monthz][next_dayz]["matches"]:
			if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
				next_match = matchz
		EmailUtil.message(next_match,EmailUtil.MESSAGE_TYPES.NEXT_MATCH)



func get_date():
	# day + 1 so 1st jan 2020 is wednsday
	return days[(date.day+2)%7] + " " + str(date.day + 1) + " " + months[date.month] + " " + str(date.year)

func get_next_match():
	for matchz in DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"]:
		if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
			return matchz


func _get_next_day_date(date):
	var unix_time = OS.get_unix_time_from_datetime(date)
	unix_time += DAY_IN_SECONDS
	var next_day = OS.get_datetime_from_unix_time(unix_time)
	next_day.erase("hour")
	next_day.erase("minute")
	next_day.erase("second")
	
	return next_day
