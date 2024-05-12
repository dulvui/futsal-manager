# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const version:String = "10052024"

#############################
# global config
#############################
var config:ConfigFile

var save_states:Array
var active_save_state:String
# for temporary save state, on creating new save state
# becomes active_save_state, once setup is completed
var temp_save_state:String

var language:String
var currency:int
var theme_index:int

#############################
# save states config
#############################
var state_config:ConfigFile

# generator
var generation_seed:String
var generation_state:int
var generation_gender:Constants.Gender
var rng:RandomNumberGenerator
var match_rng:RandomNumberGenerator

var start_date:Dictionary
# saves which season this is, starting from 0
var current_season:int
# global game states
var speed_factor:int
var dashboard_active_content:int

# resources
var leagues:Leagues
var team:Team
var manager:Manager
var transfers:Transfers
var inbox:Inbox
# saves current id for resources
var id_by_type:Dictionary

var settings_versions:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("version " + Config.version)
	
	_load_config()
	_load_resources()
	_set_up_rngs()

	Config.set_lang(language)

func _load_config() -> void:
	config = ConfigFile.new()
	var err:int = config.load("user://settings.cfg")
	# if not, something went wrong with the file loading
	if err != OK:
		print("error loading user://settings.cfg")
	currency = config.get_value("settings","currency",CurrencyUtil.Currencies.EURO)
	theme_index = config.get_value("settings","theme_index",0)
	language = config.get_value("settings","language","")
	
	save_states = config.get_value("settings","save_states",[])
	active_save_state = config.get_value("settings","active_save_state","")


func load_save_config() -> void:
	state_config = ConfigFile.new()
	var err:int = state_config.load(get_save_config_path("settings.cfg"))
	# if not, something went wrong with the file loading
	if err != OK:
		print("error loading save_settings.cfg")
		
	id_by_type = state_config.get_value("settings","id_by_type", {})
	start_date = state_config.get_value("settings","start_year",Time.get_date_dict_from_system())
	current_season = state_config.get_value("season","current_season",0)
	speed_factor = state_config.get_value("match","speed_factor",1)
	dashboard_active_content = state_config.get_value("dashboard","active_content",0)
	generation_seed = state_config.get_value("generation", "seed", Constants.DEFAULT_SEED)
	generation_state = state_config.get_value("generation", "state", 0)
	generation_gender = state_config.get_value("generation", "gender", 0)


func new_save_state() -> void:
	var state_id:String = str(int(Time.get_unix_time_from_system()))
	print("state id: ",state_id)
	temp_save_state = state_id
	load_save_config()


func get_save_config_path(path:String = "") -> String:
	if active_save_state != "":
		return "user://" + active_save_state + "/" + path
	return ""


func make_save_state_dir() -> void:
	# create save state directory, if not exist yet
	var user_dir:DirAccess = DirAccess.open("user://")
	if not user_dir.dir_exists(temp_save_state):
		active_save_state = temp_save_state
		var err:int = user_dir.make_dir(active_save_state)
		if err != OK:
			print("error while creating save state dir")


func _set_up_rngs() -> void:
	match_rng = RandomNumberGenerator.new()
	rng = RandomNumberGenerator.new()
	rng.state = generation_state
	set_seed()


func save_config() -> void:
	config.set_value("settings","currency",currency)
	config.set_value("settings","theme_index", theme_index)
	config.set_value("settings","language",language)
	config.set_value("settings","active_save_state",active_save_state)
	config.set_value("settings","save_states",save_states)

	config.save("user://settings.cfg")
	print("config saved")
	
	state_config.set_value("dates","current_season",current_season)
	state_config.set_value("match","speed_factor",speed_factor)
	state_config.set_value("settings","start_date",start_date)
	state_config.set_value("dashboard","active_content",dashboard_active_content)
	state_config.set_value("generation","seed",generation_seed)
	state_config.set_value("generation","state", generation_state)
	state_config.set_value("generation","gender",generation_gender)
	state_config.set_value("settings","id_by_type", id_by_type)
#
	state_config.save(get_save_config_path("settings.cfg"))
	print("save state config saved")


func _load_resources() -> void:
	if ResourceLoader.exists(get_save_config_path("leagues.tres")):
		print("loading user://leagues.tres")
		leagues = ResourceLoader.load(get_save_config_path("leagues.tres"))
	
	if ResourceLoader.exists(get_save_config_path("inbox.tres")):
		print("loading user://inbox.tres")
		inbox = ResourceLoader.load(get_save_config_path("inbox.tres"))
	
	if ResourceLoader.exists(get_save_config_path("team.tres")):
		print("loading user://team.tres")
		team = ResourceLoader.load(get_save_config_path("team.tres"))
	
	if ResourceLoader.exists(get_save_config_path("manager.tres")):
		print("loading user://manager.tres")
		manager = ResourceLoader.load(get_save_config_path("manager.tres"))
	
	if ResourceLoader.exists(get_save_config_path("transfers.tres")):
		print("loading user://transfers.tres")
		transfers = ResourceLoader.load(get_save_config_path("transfers.tres"))


func save_resources() -> void:
	ResourceSaver.save(leagues, get_save_config_path("leagues.tres"))
	ResourceSaver.save(inbox, get_save_config_path("inbox.tres"))
	ResourceSaver.save(team, get_save_config_path("team.tres"))
	ResourceSaver.save(manager, get_save_config_path("manager.tres"))
	ResourceSaver.save(transfers, get_save_config_path("transfers.tres"))


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
	
	MatchMaker.inizialize_matches(leagues)
	
	EmailUtil.new_message(EmailUtil.MessageTypes.NEXT_SEASON)
	Config.save_all_data()
	
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


# shortcut to active leagues calendar 
func calendar() -> Calendar:
	return Config.leagues.get_active().calendar


# disable save, too heavy on close, breaks game
# save on quit on mobile
#func _notification(what:int) -> void:
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#save_all_data()
		#get_tree().quit() # default behavior
