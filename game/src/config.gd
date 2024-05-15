# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const version:String = "1"
const config_version:String = "1"

# config
var config:ConfigFile

var language:String
var currency:int
var theme_index:int

# save states
var save_states:SaveStates

# vars
var start_date:Dictionary
# generator config
var generation_seed:String
var generation_state:int
var generation_gender:Constants.Gender
# saves which season this is, starting from 0
var current_season:int
# global game states
var speed_factor:int
var dashboard_active_content:int
# saves current id for resources
var id_by_type:Dictionary

# rng's
var rng:RandomNumberGenerator
var match_rng:RandomNumberGenerator

# resources
var leagues:Leagues
var team:Team
var manager:Manager
var transfers:Transfers
var inbox:Inbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("version " + Config.version)
	
	_load_config()
	load_save_state()

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
	
	# save states
	if ResourceLoader.exists("user://save_states.tres"):
		print("loading user://save_states.tres")
		save_states = ResourceLoader.load("user://save_states.tres")
	else:
		save_states = SaveStates.new()


func load_save_state() -> void:
	var save_sate:SaveState = save_states.get_active()
	if save_sate:
		start_date = save_sate.start_date
		id_by_type = save_sate.id_by_type
		current_season = save_sate.current_season
		speed_factor = save_sate.speed_factor
		dashboard_active_content = save_sate.dashboard_active_content
		generation_seed = save_sate.generation_seed
		generation_state = save_sate.generation_state
		generation_gender = save_sate.generation_gender
		
		_load_resources()
		_set_up_rngs()


func save_active_state() -> void:
	var save_sate:SaveState = save_states.get_active()
	save_sate.start_date = start_date
	save_sate.id_by_type = id_by_type
	save_sate.current_season = current_season
	save_sate.speed_factor = speed_factor
	save_sate.dashboard_active_content = dashboard_active_content
	save_sate.generation_seed = generation_seed
	save_sate.generation_state = generation_state
	save_sate.generation_gender = generation_gender
	
	save_resources()


func save_save_states() -> void:
	ResourceSaver.save(save_states, "user://save_states.tres")


func _set_up_rngs() -> void:
	match_rng = RandomNumberGenerator.new()
	rng = RandomNumberGenerator.new()
	rng.state = generation_state
	set_seed()


func save_config() -> void:
	config.set_value("settings","currency",currency)
	config.set_value("settings","theme_index", theme_index)
	config.set_value("settings","language",language)

	config.save("user://settings.cfg")
	print("config saved")


func _load_resources() -> void:
	if ResourceLoader.exists(save_states.get_active_path("leagues.tres")):
		print("loading user://leagues.tres")
		leagues = ResourceLoader.load(save_states.get_active_path("leagues.tres"))
	if ResourceLoader.exists(save_states.get_active_path("team.tres")):
		print("loading user://team.tres")
		team = ResourceLoader.load(save_states.get_active_path("team.tres"))
	if ResourceLoader.exists(save_states.get_active_path("manager.tres")):
		print("loading user://manager.tres")
		manager = ResourceLoader.load(save_states.get_active_path("manager.tres"))
	
	if ResourceLoader.exists(save_states.get_active_path("inbox.tres")):
		print("loading user://inbox.tres")
		inbox = ResourceLoader.load(save_states.get_active_path("inbox.tres"))
	else:
		inbox = Inbox.new()
	if ResourceLoader.exists(save_states.get_active_path("transfers.tres")):
		print("loading user://transfers.tres")
		transfers = ResourceLoader.load(save_states.get_active_path("transfers.tres"))
	else:
		transfers = Transfers.new()

func save_resources() -> void:
	ResourceSaver.save(leagues, save_states.get_active_path("leagues.tres"))
	ResourceSaver.save(inbox, save_states.get_active_path("inbox.tres"))
	ResourceSaver.save(team, save_states.get_active_path("team.tres"))
	ResourceSaver.save(manager, save_states.get_active_path("manager.tres"))
	ResourceSaver.save(transfers, save_states.get_active_path("transfers.tres"))


func generate_leagues(p_generation_seed:String, p_generation_gender:Constants.Gender) -> void:
	generation_seed = p_generation_seed
	generation_gender = p_generation_gender
	set_seed(generation_seed)
	var generator:Generator = Generator.new()
	leagues = generator.generate()


func save_all_data() -> void:
	save_active_state()
	save_resources()
	save_save_states()
	save_config()


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
