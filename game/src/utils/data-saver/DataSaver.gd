extends Node


var config

var year
var month
var day
var day_counter

var season_started
var calendar

var selected_formation
var selected_players

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
	
	selected_formation = config.get_value("season","formation","2-2")
	selected_players = config.get_value("season","players",[])
	
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
	config.set_value("season","players",selected_players)
	config.save("user://settings.cfg")

func save_manager(new_manager):
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func save_team(new_team):
	season_started = true
	team = new_team
	
	for i in range(10):
		selected_players.append(team["players"][i])
		
	
	save_all_data()
	
func save_date():
	config.set_value("current_date","year",CalendarUtil.year)
	config.set_value("current_date","month",CalendarUtil.month)
	config.set_value("current_date","day",CalendarUtil.day)
	config.set_value("current_date","day_counter",CalendarUtil.day_counter)
	config.save("user://settings.cfg")

func save_formation(formation):
	selected_formation = formation
	config.set_value("season","formation",selected_formation)
	config.save("user://settings.cfg")
	
func save_players():
	config.set_value("season","players",selected_players)
	config.save("user://settings.cfg")


func save_calendar(new_calendar):
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func change_player(player_to_replace,player):
	print("change")
	print(player_to_replace["name"])
	print(player["name"])
	var index = selected_players.find(player_to_replace)
	var index2 = selected_players.find(player)
	selected_players[index] = player
	selected_players[index2] = player_to_replace
	config.set_value("season","players",selected_players)
	config.save("user://settings.cfg")

