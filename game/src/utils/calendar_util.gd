# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const months:Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
const days:Array = ["SUN","MON","TUE","WE","THU","FRI","SAT"]
const day_in_seconds:int = 86400

var date:Dictionary

# season start at 1st of june
const season_start_day:int = 1
const season_start_month:int = 6

# season end 30th of november
const season_end_day:int = 30
const season_end_month:int = 11


# market dates
const market_periods:Array = [
	{
		"period" : "winter",
		"start" : {
			"month" : 1,
			"day" : 1,
		},
		"end" : {
			"month" : 1,
			"day" : 31,
		},
	},
	{
		"period" : "summer",
		"start" : {
			"month" : 6,
			"day" : 1,
		},
		"end" : {
			"month" : 8,
			"day" : 31,
		},
	},
]

func _ready() -> void:
	date = Config.date
	
func initial_date() -> Dictionary:
	date = Time.get_date_dict_from_system()
	
	date.day = season_start_day
	date.month = season_start_month
	return date

func create_calendar(next_season:bool = false) -> void:
	if next_season:
		Config.date.year += 1
		Config.date.day = season_start_day
		Config.date.month = season_start_month
		
		Config.date = _get_next_day(Config.date)
		date = Config.date

	
	var calendar:Array = []
	# start date in fomrat YYYY-MM-DDTHH:MM:SS
	var firstJanuary:String = str(date.year) + "-01-01T00:00:00"
	var temp_date:Dictionary = Time.get_datetime_dict_from_datetime_string(firstJanuary, true)
	
	# create months
	for i in range(0,12):
		calendar.append([])
	
	# create days
	while temp_date.year == date.year:
		var day:Dictionary = {
			"matches" : [],
			"trainings" : [],
			"market": is_market_active(temp_date),
			"weekday" : days[temp_date.weekday],
			"day" : temp_date.day - 1,
			"month" : temp_date.month - 1,
			"year" : temp_date.year - 1,
		}
		calendar[temp_date.month - 1].append(day)
		
		temp_date = _get_next_day(temp_date)

	Config.save_calendar(calendar)

func next_day() -> void:
	date = _get_next_day(date)
	Config.date = date
	
	# get email for next match
	var next_match_month:int = date.month
	var next_match_day:int = date.day
	
	# if next match is the first of the next month
	if date.day == Config.calendar[date.month - 1].size() - 1 and Config.calendar[(date.month) % 12][0]["matches"].size() > 0:
		next_match_month = date.month
		next_match_day = 0
	
	var next_match:Dictionary
	if next_match_day < Config.calendar[next_match_month].size():
		for matchz:Dictionary in Config.calendar[next_match_month][next_match_day]["matches"]:
			if matchz["home"] == Config.team.name or matchz["away"] == Config.team.name:
				next_match = matchz
	
	if next_match:
		EmailUtil.next_match(next_match)

	if is_market_active():
		print("market is active")
		
	if does_market_start_today():
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_START)
		
	if does_market_end_today():
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_END)


func format_date(p_date:Dictionary=date) -> String:
	return months[p_date.weekday] + " " + str(p_date.day + 1) + " " + months[p_date.month] + " " + str(p_date.year)


func get_next_match() -> Dictionary:
	for matchz:Dictionary in Config.calendar[Config.date.month][Config.date.day]["matches"]:
		if matchz["home"] == Config.team.name or matchz["away"] == Config.team.name:
			return matchz
	return {}


func _get_next_day(_date:Dictionary) -> Dictionary:
	# increment date by one day
	var unix_time:int = Time.get_unix_time_from_datetime_dict(_date)
	unix_time += day_in_seconds
	var _next_day:Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	_next_day.erase("hour")
	_next_day.erase("minute")
	_next_day.erase("second")
	
	return _next_day


func is_market_active(p_date:Dictionary={}) -> bool:
	var check_date:Dictionary = date
	if not p_date.is_empty():
		check_date = p_date
	
	for market_period:Dictionary in market_periods:
		if check_date.month >= market_period.start.month and check_date.day >= market_period.start.day \
			and check_date.month <=  market_period.end.month and check_date.day <=  market_period.end.day:
			return true
	return false
	
func does_market_start_today() -> bool:
	for market_period:Dictionary in market_periods:
		if date.month == market_period.start.month and date.day == market_period.start.day:
			return true
	return false
	
func does_market_end_today() -> bool:
	for market_period:Dictionary in market_periods:
		if date.month == market_period.end.month and date.day == market_period.end.day:
			return true
	return false
	
func is_season_finished() -> bool:
	return Config.date.month == season_end_month and Config.date.day == season_end_day
