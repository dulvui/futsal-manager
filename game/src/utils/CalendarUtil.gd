extends Node

const MONTHS:Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
const DAYS:Array = ["MON","TUE","WE","THU","FRI","SAT","SUN"]
const DAY_IN_SECONDS:int = 86400

var date:Dictionary

# season start at 1st of june
const START_DAY:int = 0
const START_MONTH:int = 5

# season end 30th of november
const END_DAY:int = 29
const END_MONTH:int = 10


# market dates
const MARKET_PERIODS:Array = [
	{
		"period" : "winter",
		"start" : {
			"month" : 0,
			"day" : 0,
		},
		"end" : {
			"month" : 0,
			"day" : 30,
		},
	},
	{
		"period" : "summer",
		"start" : {
			"month" : 5,
			"day" : 0,
		},
		"end" : {
			"month" : 7,
			"day" : 30,
		},
	},
]

func _ready() -> void:
	date = DataSaver.date
	
func initial_date() -> Dictionary:
	date = Time.get_date_dict_from_system()
	
	date.day = START_DAY
	date.month = START_MONTH
	return date

func create_calendar(next_season:bool = false) -> void:
	if next_season:
		DataSaver.date.year += 1
		DataSaver.date.day = START_DAY
		DataSaver.date.month = START_MONTH
		
		DataSaver.date = _get_next_day(DataSaver.date)
		date = DataSaver.date

	
	var calendar:Array = []
	var temp_date:Dictionary = date.duplicate(true)
	

	
	# create months
	for i in range(0,12):
		calendar.append([])
	
	# create days
	# TODO check if year has really 365 days
	for i in 365: 
		var day:Dictionary = {
			"matches" : [],
			"trainings" : [],
			"weekday" : DAYS[temp_date.weekday],
			"day" : temp_date.day,
			"month" : temp_date.month,
			"year" : temp_date.year,
		}
		calendar[temp_date.month].append(day)
		
		temp_date = _get_next_day(temp_date)
		
	DataSaver.save_calendar(calendar)

func next_day() -> void:
	date = _get_next_day(date)
	DataSaver.date = date
	
	# get email for next match
	var next_match_month:int = date.month
	var next_match_day:int = date.day
	
	# if next match is the first of the next month
	if date.day == DataSaver.calendar[date.month].size() - 1 and DataSaver.calendar[(date.month + 1) % 12][0]["matches"].size() > 0:
		next_match_month = date.month + 1
		next_match_day = 0
	
	var next_match:Dictionary
	if next_match_day < DataSaver.calendar[next_match_month].size():
		for matchz in DataSaver.calendar[next_match_month][next_match_day]["matches"]:
			if matchz["home"] == DataSaver.team_name or matchz["away"] == DataSaver.team_name:
				next_match = matchz
	
	if next_match:
		EmailUtil.new_message(EmailUtil.MESSAGE_TYPES.NEXT_MATCH, next_match)

	if is_market_active():
		print("market is active")
		
	if is_market_start_today():
		EmailUtil.new_message(EmailUtil.MESSAGE_TYPES.MARKET_START)
		
	if is_market_end_today():
		EmailUtil.new_message(EmailUtil.MESSAGE_TYPES.MARKET_END)


func get_dashborad_date() -> String:
	return DAYS[date.weekday] + " " + str(date.day + 1) + " " + MONTHS[date.month] + " " + str(date.year)

func get_next_match() -> Dictionary:
	for matchz in DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"]:
		if matchz["home"] == DataSaver.team_name or matchz["away"] == DataSaver.team_name:
			return matchz
	return {}


func _get_next_day(_date:Dictionary) -> Dictionary:
	# add 1, because will substract 1 in next steps
	_date.month += 1
	_date.day += 1
	_date.weekday += 1
	
	# increment date by one day
	var unix_time:int = Time.get_unix_time_from_datetime_dict(_date)
	unix_time += DAY_IN_SECONDS
	var next_day:Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	next_day.erase("hour")
	next_day.erase("minute")
	next_day.erase("second")
	
	# make date array friendly by starting from 0
	next_day.month -= 1
	next_day.day -= 1
	next_day.weekday -= 1
	
	return next_day


func is_market_active(_date:Dictionary={}) -> bool:
	var check_date = date
	if not _date.is_empty():
		check_date = _date
	
	for market_period in MARKET_PERIODS:
		if check_date.month >= market_period.start.month and check_date.day >= market_period.start.day \
			and check_date.month <=  market_period.end.month and check_date.day <=  market_period.end.day:
			return true
	return false
	
func is_market_start_today() -> bool:
	for market_period in MARKET_PERIODS:
		if date.month == market_period.start.month and date.day == market_period.start.day:
			return true
	return false
	
func is_market_end_today() -> bool:
	for market_period in MARKET_PERIODS:
		if date.month == market_period.end.month and date.day == market_period.end.day:
			return true
	return false
		
