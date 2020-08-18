extends Node


var config

var manager

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	config = ConfigFile.new()
	config.load("user://settings.cfg")
#	if err == OK: # if not, something went wrong with the file loading
	manager = config.get_value("manager", "data", {
		"name" : "",
		"nationality" : "",
		"birth_date" : "",
		"fav_team" : "",
	})
	
func save_all_data():
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")


