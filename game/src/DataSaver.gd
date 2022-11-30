extends Node

var config

var language

var calendar
var date

var leagues = {
	"IT": [
		{
			"id" : 0,
			"name" : "Serie A",
			"file" : "ita_serie_a.json",
			"teams" : []
		},
		{
			"id" : 1,
			"name" : "Serie B",
			"file" : "ita_serie_b.json",
			"teams" : []
		},
		{
			"id" : 2,
			"name" : "Serie C",
			"file" : "ita_serie_c.json",
			"teams" : []
		},
	]
}
var league_id
var team_name
var manager

var table

var current_transfers

var messages


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	language = config.get_value("settings","language","ND")
	
	calendar = config.get_value("season","calendar",[])
	table = config.get_value("season","table",{})
	current_transfers = config.get_value("season","current_transfers",[])
	
	team_name = config.get_value("team", "name", null)
	league_id = config.get_value("league", "id", null)
	leagues = config.get_value("leagues", "data", leagues)
	
	date = config.get_value("current_date","date", CalendarUtil.initial_date())
	messages = config.get_value("mail","messages",[])
	
	#connect mail util with all other utils that send messages
	
	
func reset() -> void:
	manager =  {
		"name" : "",
		"surname" : "",
		"nationality" : "",
		"birth_date" : "",
	}
	
	calendar = []
	table = {}
	current_transfers = []
	TransferUtil.current_transfers = []
	messages = []
	EmailUtil.messages = []
	
	date = CalendarUtil.initial_date()
	
func set_lang(lang) -> void:
	TranslationServer.set_locale(lang)
	language = lang
	config.set_value("settings","language", language)
	config.save("user://settings.cfg")

func save_all_data() -> void:
	config.set_value("manager","data",manager)
	config.set_value("team","name", team_name)
	config.set_value("league","id", league_id)
	config.set_value("leagues","data",leagues)
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.set_value("season","table",table)
	config.set_value("season","current_transfers",TransferUtil.current_transfers)
	config.set_value("mail","messages",EmailUtil.messages)
	config.save("user://settings.cfg")
	print("all data saved")

func save_manager(new_manager) -> void:
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func select_team(_league_id, _team_name) -> void:
#	teams = _teams.duplicate(true)
	league_id = _league_id
	team_name = _team_name
	# init table
	for team in get_teams(league_id):
		table[team["name"]] = {
			"points" : 0,
			"games_played": 0,
			"goals_made" : 0,
			"goals_against" : 0,
			"wins" : 0,
			"draws" : 0,
			"lost" : 0
		}
	save_all_data()
	
func save_date() -> void:
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func save_calendar(new_calendar) -> void:
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")
	
func make_transfer(transfer) -> void:
	#remove player from team
	print(transfer["player"])
	
	var teams = get_teams()
	
	for team in teams:
		if team["name"] == transfer["player"]["team"]:
			if team["players"]["active"].has(transfer["player"]):
				team["players"]["active"].erase(transfer["player"])
				team["players"]["active"].append(team["players"]["subs"].pop_front())
			team["players"]["subs"].erase(transfer["player"])
			team["budget"] += transfer["money"]
			for player in transfer["exchange_players"]:
				team["players"]["subs"].append(player)
	
	#add player to team
	for team in teams:
		if team["name"] == DataSaver.team_name:
			team["players"]["subs"].append(transfer["player"])
			team["budget"] -= transfer["money"]
			for player in transfer["exchange_players"]:
				if team["players"]["active"].has(player):
					team["players"]["active"].erase(player)
					team["players"]["active"].append(team["players"]["subs"].pop_front())
				team["players"]["subs"].erase(player)
			#handle also special contracts with bonus on future sell etc.


func set_table_result(home_name,home_goals,away_name,away_goals) -> void:
#	print("%s %d : %d %s"%[home_name,home_goals,away_name,away_goals])
	table[home_name]["goals_made"] += home_goals
	table[home_name]["goals_against"] += away_goals
	table[away_name]["goals_made"] += away_goals
	table[away_name]["goals_against"] += home_goals
	
	if home_goals > away_goals:
		table[home_name]["wins"] += 1
		table[home_name]["points"] += 3
		table[away_name]["lost"] += 1
	elif  home_goals == away_goals:
		table[home_name]["draws"] += 1
		table[home_name]["points"] += 1
		table[away_name]["draws"] += 1
		table[away_name]["points"] += 1
	else:
		table[away_name]["wins"] += 1
		table[away_name]["points"] += 3
		table[home_name]["lost"] += 1
	table[home_name]["games_played"] += 1
	table[away_name]["games_played"] += 1

func save_table() -> void:
	config.set_value("season","table",table)
	config.save("user://settings.cfg")
	
	
func get_selected_team() -> Dictionary:
	for team in get_teams(league_id):
		if team["name"] == team_name:
			return team
	return {}


func init_teams() -> void:
	# check if leagues not leoaded yet
	for nation in leagues:
		for league in leagues[nation]:
			var file = File.new()
			file.open("res://assets/" + league["file"], file.READ)
			var json = file.get_as_text()
			league["teams"] = JSON.parse(json).result
			file.close()

func get_teams(_league_id = null) -> Array:
	var all_teams = []
	for nation in leagues:
		for league in leagues[nation]:
			if _league_id == null:
				all_teams.append_array(league["teams"])
			else:
				if league["id"] == _league_id:
					all_teams.append_array(league["teams"])
	return all_teams


# save on quit on mobile
func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
