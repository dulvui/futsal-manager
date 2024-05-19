# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Calendar
extends Resource

const DAY_IN_SECONDS: int = 86400

# season end 30th of november
const SEASON_END_DAY: int = 30
const SEASON_END_MONTH: int = 11
# market dates
const MARKET_PERIODS:Array = [
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

@export var date: Dictionary
@export var months:Array[Month]


func _init(
		p_date: Dictionary = {},
		p_months:Array[Month] = [],
	) -> void:
	date = p_date
	months = p_months


func initialize(next_season: bool = false) -> void:
	if next_season:
		date.year += 1
		date.day = Const.SEASON_START_DAY
		date.month = Const.SEASON_START_MONTH
		
		date = _get_next_day(date)
	else:
		date = Config.start_date
	
	# start date in fomrat YYYY-MM-DDTHH:MM:SS
	var first_january:String = str(date.year) + "-01-01T00:00:00"
	var temp_date: Dictionary = Time.get_datetime_dict_from_datetime_string(first_january, true)
	
	# create months
	for month_string:String in Const.MONTH_STRINGS:
		var new_month:Month = Month.new()
		new_month.name = month_string
		months.append(new_month)
	
	# create days
	while temp_date.year == date.year:
		var new_day:Day = Day.new()
		new_day.market = is_market_active(temp_date)
		new_day.weekday =  Const.DAY_STRINGS[temp_date.weekday]
		new_day.day =  temp_date.day
		new_day.month =  temp_date.month
		new_day.year =  temp_date.year
		
		months[temp_date.month - 1].days.append(new_day)
		
		temp_date = _get_next_day(temp_date)


func next_day() -> void:
	date = _get_next_day()
	
	if is_match_day():
		EmailUtil.next_match(get_next_match())

	if does_market_start_today():
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_START)
		
	if does_market_end_today():
		EmailUtil.new_message(EmailUtil.MessageTypes.MARKET_END)


func day(p_month: int = date.month, p_day: int = date.day) -> Day:
	return months[p_month - 1].days[p_day - 1]


func month(p_month: int = date.month) -> Month:
	return months[p_month - 1]


func _get_next_day(_date: Dictionary=date) -> Dictionary:
	# increment date by one day
	var unix_time: int = Time.get_unix_time_from_datetime_dict(_date)
	unix_time += DAY_IN_SECONDS
	var _next_day: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	_next_day.erase("hour")
	_next_day.erase("minute")
	_next_day.erase("second")
	
	return _next_day


func is_match_day() -> bool:
	var next_match:Match = get_next_match()
	return next_match != null and not next_match.over


func is_market_active(p_date: Dictionary=date) -> bool:
	for market_period: Dictionary in MARKET_PERIODS:
		if p_date.month >= market_period.start.month and p_date.day >= market_period.start.day \
			and p_date.month <=  market_period.end.month and p_date.day <=  market_period.end.day:
			return true
	return false


func does_market_start_today() -> bool:
	for market_period: Dictionary in MARKET_PERIODS:
		if date.month == market_period.start.month and date.day == market_period.start.day:
			return true
	return false
	
func does_market_end_today() -> bool:
	for market_period: Dictionary in MARKET_PERIODS:
		if date.month == market_period.end.month and date.day == market_period.end.day:
			return true
	return false


func is_season_finished() -> bool:
	return date.month == SEASON_END_MONTH and date.day == SEASON_END_DAY


func format_date(p_date: Dictionary=date) -> String:
	return Const.DAY_STRINGS[p_date.weekday] + " " + str(p_date.day) + " " + Const.MONTH_STRINGS[p_date.month - 1] + " " + str(p_date.year)


func get_next_match() -> Match:
	for matchz:Match in day().matches:
		if matchz.home.name == Config.team.name or matchz.away.name == Config.team.name:
			return matchz
	return null
