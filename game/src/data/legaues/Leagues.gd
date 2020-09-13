extends Node

var serie_a = {"teams" : []}

func add_random_players():
	var file = File.new()
	file.open("res://assets/ita_serie_a.json", file.READ)
	var json = file.get_as_text()
	serie_a["teams"] = JSON.parse(json).result
	file.close()
	DataSaver.teams = serie_a.duplicate(true)
	
	for team in DataSaver.teams["teams"]: 
		DataSaver.table.append({
						   "name" : team["name"],
						   "points" : 0,
						   "games_played": 0,
						   "goals_made" : 0,
						   "goals_against" : 0,
						   "wins" : 0,
						   "draws" : 0,
						   "lost" : 0
				   })

	
	DataSaver.save_all_data()
