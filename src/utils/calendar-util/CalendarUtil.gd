extends Node

var months = ["JAN","FEB","MAR","MAY","APR","JUN","JUL","AUG","SEP","OKT","NOV","DEC"]
var days = ["MON","TUE","WE","THU","FRI","SAT","SUN"]

var year = 2020
var month = 1
var day = 1
var day_counter = 1


func _ready():
	print(get_date())

func next_day():
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
		pass
	elif month%2 == 0:
		if day > 30:
			day = 1
			month += 1
		if month == 13:
			year += 1
			day = 1
			month = 1
	else:
		if day > 31:
			day = 1
			month += 1
	print(get_date())

func get_date():
	# day + 1 so 1st jan 2020 is wednsday
	return days[(day_counter+1)%7] + " " + str(day) + " " + months[month-1] + " " + str(year)

