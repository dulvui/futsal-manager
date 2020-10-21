extends Node

var months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
var days = ["MON","TUE","WE","THU","FRI","SAT","SUN"]

var year = 2020
var month = 1
var day = 1


func _ready():
	
	year = DataSaver.year
	month = DataSaver.month
	day = DataSaver.day
	
	print(get_date())

func create_calendar():
	
	year = 2020
	month = 1
	day = 1
	
	var calendar = []
	for i in range(1,366): #3020?
		var json = {
			"day" : day,
			"year" : year,
			"matches" : [],
			"trainings" : []
		}
		if day == 1:
			calendar.append([])
		calendar[month-1].append(json)
		calc_date()
	year = 2020
	month = 1
	day = 1
	DataSaver.save_calendar(calendar)

func next_day():
	calc_date()
	
#	MatchMaker.check_date(day,month,year)
	# check contracts
	# generate random news/ emails
	# check trainings
	# player growth
	# pay players/staff
	
	
	if DataSaver.calendar[month-1][day-1]["matches"].size() > 0:
		var next_match
		for matchz in DataSaver.calendar[month-1][day-1]["matches"]:
			if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
				next_match = matchz
		EmailUtil.message(next_match,EmailUtil.MESSAGE_TYPES.NEXT_MATCH)
	

func calc_date():
	day += 1
	match month:
		2:
			if year % 4 == 0:
				if day > 29:
					day = 1
					month += 1
			else:
				if day > 28:
					day = 1
					month += 1
		1,3,5,7,8,10,12:
			if day > 31:
				day = 1
				month += 1
		4,6,9,11:
			if day > 30:
				day = 1
				month += 1
	
	
	if month == 13:
		year += 1
		day = 1
		month = 1

#	DataSaver.save_date()


func get_date():
	# day + 1 so 1st jan 2020 is wednsday
	return days[(day+1)%7] + " " + str(day) + " " + months[month-1] + " " + str(year)

func get_next_match():
	for matchz in DataSaver.calendar[month][day]["matches"]:
		if matchz["home"] == DataSaver.selected_team or matchz["away"] == DataSaver.selected_team:
			return matchz
