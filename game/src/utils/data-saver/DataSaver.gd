extends Node


var config

var year
var month
var day
var day_counter

var season_started
var calendar

var team

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
	
	calendar = config.get_value("season","calendar",[])
	
	team = config.get_value("team", "data",{})
	season_started = config.get_value("season", "started",false)
	
	year = config.get_value("current_date","year",2020)
	month = config.get_value("current_date","month",1)
	day = config.get_value("current_date","day",1)
	day_counter = config.get_value("current_date","day_counter",1)
	
func save_all_data():
	config.set_value("manager","data",manager)
	config.set_value("season","started",season_started)
	config.set_value("team","data",team)
	config.set_value("current_date","year",CalendarUtil.year)
	config.set_value("current_date","month",CalendarUtil.month)
	config.set_value("current_date","day",CalendarUtil.day)
	config.set_value("current_date","day_counter",CalendarUtil.day_counter)
	config.save("user://settings.cfg")

func save_manager(new_manager):
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func save_team(new_team):
	season_started = true
	team = new_team
	
	
	#hardcoded for now, use generator for this afterwards
	team["formation"] = "2-2"
	
	for player in team["players"]:
		player["actual_pos"] = "S"
		
	team["players"][0]["actual_pos"] = "G"
	team["players"][1]["actual_pos"] = "D"
	team["players"][2]["actual_pos"] = "WL"
	team["players"][3]["actual_pos"] = "WR"
	team["players"][4]["actual_pos"] = "P"
	
	save_all_data()
	
func save_date():
	config.set_value("current_date","year",CalendarUtil.year)
	config.set_value("current_date","month",CalendarUtil.month)
	config.set_value("current_date","day",CalendarUtil.day)
	config.set_value("current_date","day_counter",CalendarUtil.day_counter)
	config.save("user://settings.cfg")


func save_calendar(new_calendar):
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func change_player(player_to_replace,player):
	print("change player")
	player["actual_pos"] = player_to_replace["actual_pos"]
	player_to_replace["actual_pos"] = "S"

