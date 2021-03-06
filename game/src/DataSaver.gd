extends Node

var config

var language

var calendar
var date

# all teams of all leagues
var all_teams
# teams of current playing league
var teams
var selected_team
var manager

var table

var current_transfers

var messages


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
	language = config.get_value("settings","language","ND")
	
	calendar = config.get_value("season","calendar",[])
	table = config.get_value("season","table",{})
	current_transfers = config.get_value("season","current_transfers",[])
	
	selected_team = config.get_value("selected_team", "data","")
	teams = config.get_value("teams", "data",{})
	all_teams = config.get_value("all_teams", "data",{})
	
	
	date = config.get_value("current_date","date", CalendarUtil.initial_date())
	messages = config.get_value("mail","messages",[])
	
	#connect mail util with all other utils that send messages
	
	
func reset():
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
	
func set_lang(lang):
	TranslationServer.set_locale(lang)
	language = lang
	config.set_value("settings","language", language)
	config.save("user://settings.cfg")

func save_all_data():
	config.set_value("manager","data",manager)
	config.set_value("selected_team","data",selected_team)
	config.set_value("teams","data",teams)
	config.set_value("all_teams","data",all_teams)
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.set_value("season","table",table)
	config.set_value("season","current_transfers",TransferUtil.current_transfers)
	config.set_value("mail","messages",EmailUtil.messages)
	config.save("user://settings.cfg")
	print("all data saved")

func save_manager(new_manager):
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func select_team(_teams, _selected_team):
	teams = _teams.duplicate(true)
	selected_team = _selected_team["name"]
	
	all_teams = Leagues.get_all_teams()
	
	# init table
	for team in teams:
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
	
func save_date():
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func save_calendar(new_calendar):
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")
	
func make_transfer(transfer):
	#remove player from team
	print(transfer["player"])
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
		if team["name"] == DataSaver.selected_team:
			team["players"]["subs"].append(transfer["player"])
			team["budget"] -= transfer["money"]
			for player in transfer["exchange_players"]:
				if team["players"]["active"].has(player):
					team["players"]["active"].erase(player)
					team["players"]["active"].append(team["players"]["subs"].pop_front())
				team["players"]["subs"].erase(player)
			#handle also special contracts with bonus on future sell etc.
			
	
func change_player(position,player):
	var team = DataSaver.get_selected_team()
	team["players"]["subs"].append(team["players"]["active"][position])
	team["players"]["active"][position] = player
	team["players"]["subs"].erase(player)

func set_table_result(home_name,home_goals,away_name,away_goals):
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

func save_table():
	config.set_value("season","table",table)
	config.save("user://settings.cfg")
	
	
func get_selected_team():
	for team in teams:
		if team["name"] == selected_team:
			return team


# save on quit on mobile
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
