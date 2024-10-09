# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const config_version: String = "1"
var version: String = ProjectSettings.get_setting("application/config/version")

# config
var config: ConfigFile

# .res for binary/compressed resource data
# .tres for text resource data
var res_suffix: String = ".res"
#var res_suffix: String = ".tres"

# save states
var save_states: SaveStates

# vars
var language: String
var currency: int
var theme_index: int
var start_date: Dictionary
# generator config
var generation_seed: String
var generation_state: int
var generation_player_names: Const.PlayerNames
# saves which season this is, starting from 0
var current_season: int
# global game states
var speed_factor: int
# saves current id for resources
var id_by_type: Dictionary

# resources
var world: World
# active resources references, from world
var team: Team
var league: League
var manager: Manager

var transfers: Transfers
var inbox: Inbox

# saves match pause state
var match_paused: bool


func _ready() -> void:
	print("version " + Config.version)
	_load_config()
	load_save_state()
	RngUtil.set_up_rngs()
	Config.set_lang(language)


func load_save_state() -> void:
	var save_sate: SaveState = save_states.get_active()
	if save_sate:
		start_date = save_sate.start_date
		id_by_type = save_sate.id_by_type
		current_season = save_sate.current_season
		speed_factor = save_sate.speed_factor
		generation_seed = save_sate.generation_seed
		generation_state = save_sate.generation_state
		generation_player_names = save_sate.generation_player_names
		ResUtil.load_resources()
	else:
		ResUtil.load_status = ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED


func save_active_state() -> void:
	print("saving save state...")
	var save_sate: SaveState = save_states.get_active()
	save_sate.start_date = start_date
	save_sate.id_by_type = id_by_type
	save_sate.current_season = current_season
	save_sate.speed_factor = speed_factor
	save_sate.generation_seed = generation_seed
	save_sate.generation_state = generation_state
	save_sate.generation_player_names = generation_player_names

	save_sate.save_metadata()

	ResourceSaver.save(world, save_states.get_active_path("world" + res_suffix), ResourceSaver.FLAG_COMPRESS)
	ResourceSaver.save(inbox, save_states.get_active_path("inbox" + res_suffix), ResourceSaver.FLAG_COMPRESS)
	ResourceSaver.save(transfers, save_states.get_active_path("transfers" + res_suffix), ResourceSaver.FLAG_COMPRESS)
	print("save state saved")


func save_save_states() -> void:
	ResourceSaver.save(save_states, "user://save_states" + res_suffix)


func save_config() -> void:
	config.set_value("settings", "currency", currency)
	config.set_value("settings", "theme_index", theme_index)
	config.set_value("settings", "language", language)

	config.save("user://settings.cfg")


func save_all_data() -> void:
	save_active_state()
	save_save_states()
	save_config()


func set_lang(lang: String) -> void:
	TranslationServer.set_locale(lang)
	language = lang
	config.set_value("settings", "language", language)
	config.save("user://settings.cfg")


func select_team(p_league: League, p_team: Team) -> void:
	world = Config.world
	manager = Config.manager
	league = p_league
	team = p_team
	world.active_team_id = team.id
	
	print("team saved")
	transfers = Transfers.new()
	print("calendars created")
	MatchCombinationUtil.initialize_matches()
	print("matches initialized")
	inbox = Inbox.new()
	EmailUtil.welcome_manager()
	
	speed_factor = Config.save_states.temp_state.speed_factor
	start_date = Config.save_states.temp_state.start_date
	
	save_states.make_temp_active()
	save_all_data()


func next_day() -> void:
	Config.world.calendar.next_day()
	
	if Config.world.calendar.is_match_day():
		EmailUtil.next_match(Config.world.calendar.get_next_match())
	
	TransferUtil.update_day()


func next_season() -> void:
	current_season += 1

	# TODO
	# financial stuff
	# set new goals for manager
	# player contracts
	# transfer markets
	# save competition results in history
	
	PlayerProgress.players_progress_season()
	
	world.promote_and_delegate_teams()
	
	world.calendar.initialize(true)
	
	MatchCombinationUtil.initialize_matches()
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _load_config() -> void:
	config = ConfigFile.new()
	var err: int = config.load("user://settings.cfg")
	# if not, something went wrong with the file loading
	if err != OK:
		print("error loading user://settings.cfg")
	currency = config.get_value("settings", "currency", FormatUtil.Currencies.EURO)
	theme_index = config.get_value("settings", "theme_index", 0)
	language = config.get_value("settings", "language", "")

	# save states
	if ResourceLoader.exists("user://save_states" + res_suffix):
		print("loading user://save_states" + res_suffix)
		save_states = ResourceLoader.load("user://save_states" + res_suffix)
	else:
		save_states = SaveStates.new()


# disable save, too heavy on close, breaks game
# save on quit on mobile
#func _notification(what: int) -> void:
#if what == NOTIFICATION_WM_CLOSE_REQUEST:
#save_all_data()
#get_tree().quit() # default behavior
