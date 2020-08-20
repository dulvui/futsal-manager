extends Node


var config

var year
var month
var day
var day_counter

var manager

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	config = ConfigFile.new()
	config.load("user://settings.cfg")
#	if err == OK: # if not, something went wrong with the file loading
	manager = config.get_value("manager", "data", {
		"name" : "",
		"surname" : "",
		"nationality" : "",
		"birth_date" : "",
	})
	
	year = config.get_value("current_date","year",2020)
	month = config.get_value("current_date","month",1)
	day = config.get_value("current_date","day",1)
	day_counter = config.get_value("current_date","day_counter",1)
	
func save_all_data():
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")

func save_manager(new_manager):
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
	
func save_date():
	config.set_value("current_date","year",CalendarUtil.year)
	config.set_value("current_date","month",CalendarUtil.month)
	config.set_value("current_date","day",CalendarUtil.day)
	config.set_value("current_date","day_counter",CalendarUtil.day_counter)
	config.save("user://settings.cfg")


