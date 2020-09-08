extends Node


var config

var year
var month
var day
var day_counter

var season_started
var calendar

var team
var teams
var table

var current_transfers

var messages

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
	table = config.get_value("season","table",[])
	current_transfers = config.get_value("season","current_transfers",[])
	
	team = config.get_value("team", "data",{})
	teams = config.get_value("teams", "data",[])
	season_started = config.get_value("season", "started",false)
	
	year = config.get_value("current_date","year",2020)
	month = config.get_value("current_date","month",1)
	day = config.get_value("current_date","day",1)
	day_counter = config.get_value("current_date","day_counter",1)
	
	messages = config.get_value("mail","messages",[])
	
	#connect mail util with all other utils that send messages
	TransferUtil.connect("transfer_mail",EmailUtil,"message")
	
func reset():
	manager =  {
		"name" : "",
		"surname" : "",
		"nationality" : "",
		"birth_date" : "",
	}
	
	calendar = []
	table = []
	
	
	year = 2020
	month = 1
	day = 1
	day_counter = 1
	
	
func save_all_data():
	config.set_value("manager","data",manager)
	config.set_value("season","started",season_started)
	config.set_value("team","data",team)
	config.set_value("teams","data",teams)
	config.set_value("current_date","year",CalendarUtil.year)
	config.set_value("current_date","month",CalendarUtil.month)
	config.set_value("current_date","day",CalendarUtil.day)
	config.set_value("current_date","day_counter",CalendarUtil.day_counter)
	config.set_value("season","calendar",calendar)
	config.set_value("season","table",table)
	config.set_value("season","current_transfers",current_transfers)
	config.set_value("mail","messages",messages)
	config.save("user://settings.cfg")
	print("all data saved")

func save_manager(new_manager):
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func save_team(new_team):
	season_started = true
	team = new_team
	
	
	#hardcoded for now, use generator for this afterwards
	team["formation"] = "2-2"
	
	team["offensive_tactics"] = {
		"O1" : 10,
		"O2" : 10,
		"O3" : 10,
		"O4" : 10
	}
	
	team["defensive_tactics"] = {
		"D1" : 10,
		"D2" : 10,
		"D3" : 10,
		"D4" : 10
	}
	
func save_date():
	config.set_value("current_date","year",CalendarUtil.year)
	config.set_value("current_date","month",CalendarUtil.month)
	config.set_value("current_date","day",CalendarUtil.day)
	config.set_value("current_date","day_counter",CalendarUtil.day_counter)
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func save_calendar(new_calendar):
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func change_player(position,player):
	print("change player")
	team["players"]["subs"].append(team["players"][position])
	team["players"][position] = player
	team["players"]["subs"].erase(player)
	
	for new_team in teams:
		if new_team["name"] == team["name"]:
			team = new_team

func save_result(home_name,home_goals,away_name,away_goals):
#	print("%s %d : %d %s"%[home_name,home_goals,away_name,away_goals])
	for team in table:
		if team["name"] == home_name:
			team["goals_made"] += home_goals
			team["goals_against"] += away_goals
			if home_goals > away_goals:
				team["wins"] += 1
				team["points"] += 3
			elif  home_goals == away_goals:
				team["draws"] += 1
				team["points"] += 1
			else:
				team["lost"] += 1
			team["games_played"] += 1
			
		elif team["name"] == away_name:
			team["goals_made"] += away_goals
			team["goals_against"] += home_goals
			if away_goals > home_goals:
				team["wins"] += 1
				team["points"] += 3
			elif  home_goals == away_goals:
				team["draws"] += 1
				team["points"] += 1
			else:
				team["lost"] += 1
			team["games_played"] += 1
	config.set_value("season","table",table)
	config.save("user://settings.cfg")
