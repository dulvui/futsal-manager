# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

import json


calendar = []
day = 1
day_counter = 1
month = 1
year = 2020


def calc_date():
	global day
	global month
	global year
	global day_counter

	day += 1
	day_counter += 1
	
	if month == 2:
			if year % 4 == 0:
				if day > 29:
					day = 1
					month += 1
			else:
				if day > 28:
					day = 1
					month += 1
	elif month == 1 or month == 3 or month == 5 or month == 7 or month == 8 or month == 10 or month == 12:
			if day > 31:
				day = 1
				month += 1
	elif day > 30:
			day = 1
			month += 1
	
	
	if month == 13:
		year += 1
		day = 1
		month = 1


for _ in range(3650):
	json_day = {
		"day" : day,
		"month" : month,
		"year" : year,
		"matches" : [],
		"trainings" : []
	}
	calendar.append(json_day)
	calc_date()

with open('calendar.json', 'w') as outfile:
	json.dump(calendar, outfile)