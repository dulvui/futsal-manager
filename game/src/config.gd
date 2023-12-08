# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var config:ConfigFile

var calendar:Array
var date:Dictionary

# saves wich season this is, starting from 0
var current_season:int

var league:League
var leagues:Array[League]

var team:Team
var manager:Dictionary

var table:Dictionary

var current_transfers:Array[Transfer]

var messages:Array


# global game states
var speed_factor:int = 0
var dashboard_active_content:int = 0

# from settings screen
var language:String
var currency:int


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
	
	current_season = config.get_value("season","current_season",0)
	
	calendar = config.get_value("season","calendar",[])
	table = config.get_value("season","table",{})
	current_transfers = config.get_value("season","current_transfers",current_transfers)
	
	team = config.get_value("resources", "team", null)
	leagues = config.get_value("resources", "leagues", init_leagues())
	league = config.get_value("resources", "league", null)
	
	date = config.get_value("current_date","date", CalendarUtil.initial_date())
	messages = config.get_value("mail","messages",[])

	# global game states
	speed_factor = config.get_value("match","speed_factor",0)
	dashboard_active_content = config.get_value("dashboard","active_content",0)
	
	# settings
	language = config.get_value("settings","language","ND")
	currency = config.get_value("settings","currency",CurrencyUtil.Currencies.EURO)
	
	
func reset() -> void:
	manager =  {
		"name" : "",
		"surname" : "",
		"nationality" : "",
		"birth_date" : "",
	}
	
	current_season = 0
	calendar = []
	table = {}
	current_transfers = []
	TransferUtil.current_transfers = []
	messages = []
	EmailUtil.messages = []
	
	date = CalendarUtil.initial_date()
	

func set_lang(lang:String) -> void:
	TranslationServer.set_locale(lang)
	language = lang
	config.set_value("settings","language", language)
	config.save("user://settings.cfg")

func save_all_data() -> void:
	config.set_value("manager","data",manager)
	config.set_value("resources","team", team)
	config.set_value("resources","league", league)
	config.set_value("resources","leagues",leagues)
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.set_value("season","table",table)
	config.set_value("season","current_transfers",TransferUtil.current_transfers)
	config.set_value("mail","messages",EmailUtil.messages)
	config.set_value("season","current_season",current_season)
	config.set_value("match","speed_factor",speed_factor)
	config.set_value("settings","currency",currency)
	config.set_value("dashboard","active_content",dashboard_active_content)

	config.save("user://settings.cfg")
	print("all data saved")

func save_manager(new_manager:Dictionary) -> void:
	manager = new_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func select_team(_league:League, _team:Team) -> void:
	league = _league
	team = _team
	# init table
	for team in league.teams:
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

func save_calendar(new_calendar:Array) -> void:
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func set_table_result(home_name:String,home_goals:int,away_name:String,away_goals:int) -> void:
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
	
	
func init_leagues() -> Array[League]:
	# check if leagues not leoaded yet
	var all_leagues:Array[League] = []
	for file in Constants.LEAGUES_FILES:
		var league:League = load(Constants.LEAGUES_DIR + file)
		all_leagues.append(league)
	
	return all_leagues
	
func next_season() -> void:
	current_season += 1
		
	# TODO
	# teams go to upper/lower division
	# financial stuff
	# set new goals for manager
	# player contracts
	
	PlayerProgress.players_progress_season()
	
	CalendarUtil.create_calendar(true)
	MatchMaker.inizialize_matches()
	
	EmailUtil.new_message(EmailUtil.MessageTypes.NEXT_SEASON)
	Config.save_all_data()
	
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


# save on quit on mobile
func _notification(what:int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
