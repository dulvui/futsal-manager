extends Node

var matches = []
var match_day = 0


func inizialize_matches():
	var teams = Leagues.serie_a["teams"].duplicate(true)
	matches = []
	match_day = 0
	
	var random_teams  = teams.duplicate(true) # = teams.duplicate(true)
	random_teams.shuffle()
	
	var last_team = random_teams.pop_front()
	
	for i in random_teams.size():
		var current_match_day = []
		var matchOne = {"home": last_team["name"],"away": random_teams[0]["name"], "result":":"}
		current_match_day.append(matchOne)
		
		var copy = random_teams.duplicate(true)
		copy.remove(0)
		
		for j in range(0,(teams.size()/2) - 1):
			var home_index = j
			var away_index = - j - 1
			
			var matchTwo = {"home": copy[away_index]["name"],"away":copy[home_index]["name"], "result":":"}
			
			current_match_day.append(matchTwo)
		matches.append(current_match_day)
		_shift_array(random_teams)
		
		
	# ritorno
	var temp_matches = []
	for match_dayz in matches:
		var current_match_dayz = []
		for matchess in match_dayz:
			var matchzz = {"home": matchess["away"],"away": matchess["home"], "result":":"}
			current_match_dayz.append(matchzz)
		temp_matches.append(current_match_dayz)
		
	for temp in temp_matches:
		matches.append(temp)
	
	
	#add to calendar
	var day = 3 # beacuse year starts with wensday
	for c_match_days in matches:
		DataSaver.calendar[day]["matches"] = c_match_days
		day += 7
		
func _shift_array(array):
	var temp = array[0]
	for i in range(array.size() - 1):
		array[i] = array[i+1]
	array[array.size() - 1] = temp
