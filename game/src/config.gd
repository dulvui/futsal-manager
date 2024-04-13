# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var config:ConfigFile

# generator
var generation_seed:String
var generation_state:int
var generation_gender:Constants.Gender
var rng:RandomNumberGenerator
var match_rng:RandomNumberGenerator

var start_date:Dictionary
# saves wich season this is, starting from 0
var current_season:int
# global game states
var speed_factor:int = 1
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
# saves current id for resources
var id_by_type:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_config()
	_load_resources()
	match_rng = RandomNumberGenerator.new()
	rng = RandomNumberGenerator.new()
	rng.state = generation_state
	set_seed()

func _load_config() -> void:
	config = ConfigFile.new()
	var err:int = config.load("user://settings.cfg")
	# if not, something went wrong with the file loading
	if err != OK:
		print("error loading user://settings.cfg")
	current_season = config.get_value("season","current_season",0)
	id_by_type = config.get_value("settings","id_by_type", {})
	# global game states
	speed_factor = config.get_value("match","speed_factor",1)
	dashboard_active_content = config.get_value("dashboard","active_content",0)
	# settings
	language = config.get_value("settings","language","ND")
	start_date = config.get_value("settings","start_year",Time.get_date_dict_from_system())
	currency = config.get_value("settings","currency",CurrencyUtil.Currencies.EURO)
	generation_seed = config.get_value("generation", "seed", Constants.DEFAULT_SEED)
	generation_state = config.get_value("generation", "state", 0)
	generation_gender = config.get_value("generation", "gender", 0)

func save_config() -> void:
	config.set_value("dates","current_season",current_season)
	config.set_value("match","speed_factor",speed_factor)
	config.set_value("settings","currency",currency)
	config.set_value("settings","start_date",start_date)
	config.set_value("dashboard","active_content",dashboard_active_content)
	config.set_value("generation","seed",generation_seed)
	config.set_value("generation","state", generation_state)
	config.set_value("generation","gender",generation_gender)
	config.set_value("settings","id_by_type", id_by_type)
#
	config.save("user://settings.cfg")
	print("all data saved")

func _load_resources() -> void:
	if ResourceLoader.exists("user://leagues.tres"):
		leagues = ResourceLoader.load("user://leagues.tres")
	if ResourceLoader.exists("user://inbox.tres"):
		inbox = ResourceLoader.load("user://inbox.tres")
	if ResourceLoader.exists("user://team.tres"):
		team = ResourceLoader.load("user://team.tres")
	if ResourceLoader.exists("user://manager.tres"):
		manager = ResourceLoader.load("user://manager.tres")
	if ResourceLoader.exists("user://transfers.tres"):
		transfers = ResourceLoader.load("user://transfers.tres")

func save_resources() -> void:
	ResourceSaver.save(leagues, "user://leagues.tres")
	ResourceSaver.save(inbox, "user://inbox.tres")
	ResourceSaver.save(team, "user://team.tres")
	ResourceSaver.save(manager, "user://manager.tres")
	ResourceSaver.save(transfers, "user://transfers.tres")
	

func generate_leagues(p_generation_seed:String, p_generation_gender:Constants.Gender) -> void:
	generation_seed = p_generation_seed
	generation_gender = p_generation_gender
	set_seed(generation_seed)
	var generator:Generator = Generator.new()
	leagues = generator.generate()

func save_all_data() -> void:
	save_resources()
	save_config()
	
func reset() -> void:
	# CONFIG
	id_by_type = {}
	start_date = Time.get_date_dict_from_system()
	current_season = 0
	generation_state = 0
	rng.state = generation_state
	# RESOURCES
	manager =  Manager.new()
	inbox = Inbox.new()
	transfers = Transfers.new()
	leagues = Leagues.new()

func set_seed(p_generation_seed:String=generation_seed) -> void:
	generation_seed = p_generation_seed
	rng.seed = hash(generation_seed) + generation_gender

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
	leagues.active_id = p_league.id
	team = p_team
	
func next_season() -> void:
	current_season += 1
		
	# TODO
	# teams go to upper/lower division
	# financial stuff
	# set new goals for manager
	# player contracts
	
	PlayerProgress.players_progress_season()
	
	for league:League in Config.leagues.list:
		league.calendar.initialize(true)
	
	MatchMaker.inizialize_matches()
	
	EmailUtil.new_message(EmailUtil.MessageTypes.NEXT_SEASON)
	Config.save_all_data()
	
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")

# shortcut to active leagues calendar 
func calendar() -> Calendar:
	return Config.leagues.get_active().calendar

# save on quit on mobile
func _notification(what:int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_all_data()
		get_tree().quit() # default behavior
