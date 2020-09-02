extends Node


var free_agents
var players

func _ready():
	var file = File.new()
	file.open("res://src/data/ita-players.json", file.READ)
	var json = file.get_as_text()
	print(JSON.parse(json).error_string)
	players = JSON.parse(json).result
	file.close()
	
	print("players loaded")



