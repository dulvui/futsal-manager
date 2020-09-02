extends Node


var serie_a = {
	"teams" : [
		{
			"id":1,
			"name": "Centro",
			"budget" : 10000,
			"stadium" : {
				"name" : "Estadio Central",
				"capacity" : 200
			},
			"players" : {},
			"prestige" : 12
		},
		{
			"id":2,
			"name": "Niquia",
			"budget" : 50000,
			"stadium" : {
				"name" : "Cancha del Norte",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":3,
			"name": "Robledo",
			"budget" : 50000,
			"stadium" : {
				"name" : "San German Arena",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":4,
			"name": "Suramericana",
			"budget" : 50000,
			"stadium" : {
				"name" : "Arena del Sur",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":5,
			"name": "Cisneros",
			"budget" : 50000,
			"stadium" : {
				"name" : "Cancha Comunal Cisneros",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":6,
			"name": "Floresta",
			"budget" : 50000,
			"stadium" : {
				"name" : "Cancha Santa Lucia",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":7,
			"name": "Envigado",
			"budget" : 50000,
			"stadium" : {
				"name" : "Envigadio",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":8,
			"name": "Bello",
			"budget" : 50000,
			"stadium" : {
				"name" : "Estadio Bello",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		},
		{
			"id":9,
			"name": "San Javier",
			"budget" : 50000,
			"stadium" : {
				"name" : "Comuna 13",
				"capacity" : 400
			},
			"players" : {},
			"prestige" : 10
		},
		{
			"id":10,
			"name": "El Poblado",
			"budget" : 50000,
			"stadium" : {
				"name" : "Galizia Stadium",
				"capacity" : 1000
			},
			"players" : {},
			"prestige" : 16
		}
	],
	"match_day" : 0,
	"games" : [],
	"last_year_table" : [
		{
			"id" : 1,
			"points" : 0,
			"games_played": 0,
			"goals_made" : 0,
			"goals_against" : 0
		}
	],
	"table" : [
		{
			"id" : 1,
			"points" : 0,
			"games_played": 0,
			"goals_made" : 0,
			"goals_against" : 0
		}
	]
}

func add_random_players():
	var i = 0
	var teams = []
	for team in serie_a["teams"]:
		var shirtnumber = 1
		var players = Players.players.slice(i,i+20,1,true)
		
		for player in players:
			player["team"] = team["name"]
			player["nr"] = shirtnumber
			player["has_ball"] = false
			shirtnumber += 1
		
		
		i += 20
		
		team["players"]["G"] = players.pop_back()
		team["players"]["D"] = players.pop_back()
		team["players"]["WL"] = players.pop_back()
		team["players"]["WR"] = players.pop_back()
		team["players"]["P"] = players.pop_back()
		
		team["players"]["subs"] = []
		
		for player in players:
			team["players"]["subs"].append(player)
		teams.append(team)
	DataSaver.teams = teams.duplicate(true)
	DataSaver.save_all_data()
