# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Calendar
extends Resource

const month_strings:Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
const day_strings:Array = ["SUN","MON","TUE","WE","THU","FRI","SAT"]
const day_in_seconds:int = 86400
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

@export var date:Dictionary
@export var start_date:Dictionary
@export var months:Array[Month]


func _init(
		p_date:Dictionary = initial_date(),
		p_months:Array[Month] = [],
		p_start_date:Dictionary = initial_date(),
	) -> void:
	date = p_date
	months = p_months
	start_date = p_start_date

func initial_date() -> Dictionary:
	date = Time.get_date_dict_from_system()
	date.day = season_start_day
	date.month = season_start_month
	return date

func initialize(next_season:bool = false) -> void:
	if next_season:
		date.year += 1
		date.day = season_start_day
		date.month = season_start_month
		
		date = _get_next_day(date)
	
	# start date in fomrat YYYY-MM-DDTHH:MM:SS
	var firstJanuary:String = str(date.year) + "-01-01T00:00:00"
	var temp_date:Dictionary = Time.get_datetime_dict_from_datetime_string(firstJanuary, true)
	
	# create months
	for month_string:String in month_strings:
		var new_month:Month = Month.new()
		new_month.name = month_string
		months.append(new_month)
	
	# create days
	while temp_date.year == date.year:
		var new_day:Day = Day.new()
		new_day.market = is_market_active(temp_date)
		new_day.weekday =  day_strings[temp_date.weekday]
		new_day.day =  temp_date.day
		new_day.month =  temp_date.month
		new_day.year =  temp_date.year
		
		months[temp_date.month - 1].days.append(new_day)
		
		temp_date = _get_next_day(temp_date)

func next_day() -> void:
	date = _get_next_day()
	
	var next_match_month:int = date.month
	var next_match_day:int = date.day
	
	# if next match is the first of the next month
	if date.day == months[date.month - 1].size() - 1 and months[(date.month - 1) % 11].days[0].matches.size() > 0:
		next_match_month = date.month
		next_match_day = 0
	
	# get next match, if it exists on next day
	var next_match:Match
	if next_match_day < months[next_match_month].size():
		for matchz:Match in months[next_match_month - 1].days[next_match_day].matches:
			if matchz.home.name == Config.team.name or matchz.away.name == Config.team.name:
				next_match = matchz
	
	# get email for next match
	if next_match:
		EmailUtil.next_match(next_match)

	if is_market_active():
		print("market is active")
		
	if does_market_start_today():
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_START)
		
	if does_market_end_today():
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_END)

func day(p_month:int = date.month - 1, p_day:int = date.day - 1) -> Day:
	return months[p_month].days[p_day]
	
func month(p_month:int = date.month - 1) -> Month:
	return months[p_month]

func _get_next_day(_date:Dictionary=date) -> Dictionary:
	# increment date by one day
	var unix_time:int = Time.get_unix_time_from_datetime_dict(_date)
	unix_time += day_in_seconds
	var _next_day:Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	_next_day.erase("hour")
	_next_day.erase("minute")
	_next_day.erase("second")
	
	return _next_day

func is_match_day() -> bool:
	return get_next_match() != null

func is_market_active(p_date:Dictionary=date) -> bool:
	for market_period:Dictionary in market_periods:
		if p_date.month >= market_period.start.month and p_date.day >= market_period.start.day \
			and p_date.month <=  market_period.end.month and p_date.day <=  market_period.end.day:
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
	return date.month == season_end_month and date.day == season_end_day

func format_date(p_date:Dictionary=date) -> String:
	return day_strings[p_date.weekday] + " " + str(p_date.day) + " " + month_strings[p_date.month] + " " + str(p_date.year)

func get_next_match() -> Match:
	for matchz:Match in day().matches:
		if matchz["home"] == Config.team.name or matchz["away"] == Config.team.name:
			return matchz
	return null
