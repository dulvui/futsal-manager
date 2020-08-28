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
		var matchOne = {"home": last_team["name"],"away": random_teams[0]["name"], "result":":"}
		matches.append(matchOne)
		
		var copy = random_teams.duplicate(true)
		copy.remove(0)
		
		for j in range(0,(teams.size()/2) - 1):
			var home_index = j
			var away_index = - j - 1
			
			var matchTwo = {"home": copy[away_index]["name"],"away":copy[home_index]["name"], "result":":"}
			
			matches.append(matchTwo)
		_shift_array(random_teams)
		
	# ritorno
	for i in range(matches.size()):
		var matchzz = {"home": matches[i]["away"],"away": matches[i]["home"], "result":":"}
		matches.append(matchzz)
	
	#add to calendar
	
	var day = 3
	for i in range(0,matches.size(),5):
		for j in range(i,i+5):
			DataSaver.calendar[day]["matches"].append(matches[j])
		day += 7


func _shift_array(array):
	var temp = array[0]
	for i in range(array.size() - 1):
		array[i] = array[i+1]
	array[array.size() - 1] = temp