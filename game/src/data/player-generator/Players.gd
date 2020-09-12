extends Node


var free_agents
var players

func _ready():
	var file = File.new()
	file.open("res://assets/players.json", file.READ)
	var json = file.get_as_text()
	players = JSON.parse(json).result
	file.close()
	



