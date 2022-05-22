extends Node

var leagues = {
	"IT": {
		"ita_serie_a" : {"teams" : []},
		"ita_serie_b" : {"teams" : []},
		"ita_serie_c" : {"teams" : []},
	}
}


func init_teams():
	for nation in leagues:
		for league in leagues[nation]:
			var file = File.new()
			file.open("res://assets/" + league + ".json", file.READ)
			var json = file.get_as_text()
			leagues[nation][league]["teams"] = JSON.parse(json).result
			file.close()

func get_all_teams():
	var all_teams = [] 
	for nation in leagues:
		for league in leagues[nation]:
			all_teams.append_array(leagues[nation][league]["teams"].duplicate(true))
	return all_teams
