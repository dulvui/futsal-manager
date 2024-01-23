# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var config:ConfigFile

# CONFIG
var generation_seed:String
var calendar:Array
var date:Dictionary
# saves wich season this is, starting from 0
var current_season:int
# global game states
var speed_factor:int = 0
var dashboard_active_content:int = 0
# from settings screen
var language:String
var currency:int

# RESOURCES
var leagues:Leagues
var team:Team
var manager:Manager
var transfers:Transfers
var inbox:Inbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_config()
	_load_resources()

func _load_config() -> void:
	config = ConfigFile.new()
	var err:int = config.load("user://settings.cfg")
	# if not, something went wrong with the file loading
	if err != OK:
		print("error loading user://settings.cfg")
	current_season = config.get_value("season","current_season",0)
	calendar = config.get_value("season","calendar",[])
	date = config.get_value("current_date","date", CalendarUtil.initial_date())
	# global game states
	speed_factor = config.get_value("match","speed_factor",0)
	dashboard_active_content = config.get_value("dashboard","active_content",0)
	# settings
	language = config.get_value("settings","language","ND")
	currency = config.get_value("settings","currency",CurrencyUtil.Currencies.EURO)
	generation_seed = config.get_value("settings", "generation_seed", Constants.DEFAULT_SEED)

func save_config() -> void:
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.set_value("season","current_season",current_season)
	config.set_value("match","speed_factor",speed_factor)
	config.set_value("settings","currency",currency)
	config.set_value("settings","generation_seed",generation_seed)
	config.set_value("dashboard","active_content",dashboard_active_content)
#
	config.save("user://settings.cfg")
	print("all data saved")

func _load_resources() -> void:
	leagues = ResourceLoader.load("user://leagues.tres")
	inbox = ResourceLoader.load("user://inbox.tres")
	team = ResourceLoader.load("user://team.tres")
	manager = ResourceLoader.load("user://manager.tres")
	transfers = ResourceLoader.load("user://transfers.tres")


func save_resources() -> void:
	ResourceSaver.save(leagues, "user://leagues.tres")
	ResourceSaver.save(inbox, "user://inbox.tres")
	ResourceSaver.save(team, "user://team.tres")
	ResourceSaver.save(manager, "user://manager.tres")
	ResourceSaver.save(transfers, "user://transfers.tres")

func generate_leagues(p_generation_seed:String) -> void:
	generation_seed = p_generation_seed
	var generator:Generator = Generator.new()
	leagues = generator.generate(generation_seed)

func save_all_data() -> void:
	save_resources()
	save_config()
	
func reset() -> void:
	# CONFIG
	date = CalendarUtil.initial_date()
	current_season = 0
	calendar = []
	# RESOURCES
	manager =  Manager.new()
	inbox = Inbox.new()
	transfers = Transfers.new()

func set_lang(lang:String) -> void:
	TranslationServer.set_locale(lang)
	language = lang
	config.set_value("settings","language", language)
	config.save("user://settings.cfg")


func save_manager(p_manager:Manager) -> void:
	manager = p_manager
	config.set_value("manager","data",manager)
	config.save("user://settings.cfg")
	
func select_team(p_league:League, p_team:Team) -> void:
	#active_league_rid = p_league.get_rid()
	team = p_team
	
func save_date() -> void:
	config.set_value("current_date","date",CalendarUtil.date)
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")

func save_calendar(new_calendar:Array) -> void:
	calendar = new_calendar
	config.set_value("season","calendar",calendar)
	config.save("user://settings.cfg")
	
	
func initial_leagues() -> Leagues:
	# check if leagues not leoaded yet
	var init_leagues:Leagues = Leagues.new()
	for file in Constants.LEAGUES_FILES:
		var league:League = ResourceLoader.load(Constants.LEAGUES_DIR + file)
		league.resource_local_to_scene = true
		init_leagues.list.append(league.duplicate(true))
	
	return init_leagues
	
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
