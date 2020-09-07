
calendar = []

day = 1
day_counter = 1
month = 1
year = 2020


def calc_date():
	day += 1
	day_counter += 1
	
	switch month:
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
		4,5,6,9,11:
			if day > 30:
				day = 1
				month += 1
	
	
	if month == 13:
		year += 1
		day = 1
		month = 1

for i in 365:
    day = 