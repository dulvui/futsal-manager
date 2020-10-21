extends Node

var months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
var days = ["MON","TUE","WE","THU","FRI","SAT","SUN"]

var year = 2020
var month = 0
var day = 0


func _ready():
	
	year = DataSaver.year
	month = DataSaver.month
	day = DataSaver.day
	
	print(get_date())

func create_calendar():
	
	year = 2020
	month = 0
	day = 0
	
	var calendar = []
	for i in 365: #3020?
		var json = {
			"day" : day,
			"year" : year,
			"matches" : [],
			"trainings" : []
		}
		if day == 0:
			calendar.append([])
		calendar[month].append(json)
		calc_date(true)
	year = 2020
	month = 0
	day = 0
	DataSaver.save_calendar(calendar)

func next_day():
	calc_date()
	
#	MatchMaker.check_date(day,month,year)
	# check contracts
	# generate random news/ emails
	# check trainings
	# player growth
	# pay players/staff
	
	# TODO check month bounds
	if DataSaver.calendar[month][day + 1]["matches"].size() > 0:
		var next_match
		for matchz in DataSaver.calendar[month][day + 1]["matches"]:
			if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
				next_match = matchz
		EmailUtil.message(next_match,EmailUtil.MESSAGE_TYPES.NEXT_MATCH)
	

func calc_date(start_up=false):
	day += 1
	match month + 1:
		2:
			if year % 4 == 0:
				if day > 29:
					day = 0
					month += 1
			else:
				if day > 28:
					day = 0
					month += 1
		1,3,5,7,8,10,12:
			if day > 31:
				day = 0
				month += 1
		4,6,9,11:
			if day > 30:
				day = 0
				month += 1
	
	
	if month == 13:
		year += 1
		day = 0
		month = 0
		
	# to save date only on next date, not on calendar creation
	if not start_up:
		DataSaver.day = day
		DataSaver.month = month
		DataSaver.year = year


func get_date():
	# day + 1 so 1st jan 2020 is wednsday
	return days[(day)%7] + " " + str(day) + " " + months[month] + " " + str(year)

func get_next_match():
	for matchz in DataSaver.calendar[DataSaver.month][DataSaver.day]["matches"]:
		if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
			return matchz
