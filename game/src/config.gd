# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const VERSION: String = "0.2.3"
const CONFIG_VERSION: String = "1"

# config
var config: ConfigFile

var language: String
var currency: int
var theme_index: int

# save states
var save_states: SaveStates

# vars
var start_date: Dictionary
# generator config
var generation_seed: String
var generation_state: int
var generation_gender: Const.Gender
# saves which season this is, starting from 0
var current_season: int
# global game states
var speed_factor: int
# saves current id for resources
var id_by_type: Dictionary

# rng's
var rng: RandomNumberGenerator
var match_rng: RandomNumberGenerator

# resources
var world: World
# active resources references
var team: Team
var league: League
var tournaments: Array[Tournament]
var manager: Manager

var calendar: Calendar
var transfers: Transfers
var inbox: Inbox

# saves match pause state
var match_paused: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("version " + Config.VERSION)
	_load_config()
	load_save_state()
	Config.set_lang(language)


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
	if ResourceLoader.exists("user://save_states.tres"):
		print("loading user://save_states.tres")
		save_states = ResourceLoader.load("user://save_states.tres")
	else:
		save_states = SaveStates.new()


func load_save_state() -> void:
	var save_sate: SaveState = save_states.get_active()
	if save_sate:
		start_date = save_sate.start_date
		id_by_type = save_sate.id_by_type
		current_season = save_sate.current_season
		speed_factor = save_sate.speed_factor
		generation_seed = save_sate.generation_seed
		generation_state = save_sate.generation_state
		generation_gender = save_sate.generation_gender
		_load_resources()
		_set_up_rngs()


func save_active_state() -> void:
	var save_sate: SaveState = save_states.get_active()
	save_sate.start_date = start_date
	save_sate.id_by_type = id_by_type
	save_sate.current_season = current_season
	save_sate.speed_factor = speed_factor
	save_sate.generation_seed = generation_seed
	save_sate.generation_state = generation_state
	save_sate.generation_gender = generation_gender

	save_sate.save_metadata()

	ResourceSaver.save(world, save_states.get_active_path("world.tres"))
	ResourceSaver.save(inbox, save_states.get_active_path("inbox.tres"))
	ResourceSaver.save(team, save_states.get_active_path("team.tres"))
	ResourceSaver.save(manager, save_states.get_active_path("manager.tres"))
	ResourceSaver.save(transfers, save_states.get_active_path("transfers.tres"))


func save_save_states() -> void:
	ResourceSaver.save(save_states, "user://save_states.tres")


func _set_up_rngs() -> void:
	match_rng = RandomNumberGenerator.new()
	rng = RandomNumberGenerator.new()
	rng.seed = hash(generation_seed) + generation_gender
	rng.state = generation_state


func reset_seed(p_generation_seed: String, p_generation_gender: int) -> void:
	generation_seed = p_generation_seed
	generation_gender = p_generation_gender
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(generation_seed + str(generation_gender))
	generation_state = rng.state
	#print(generation_seed)
	#print(rng.seed)
	#print(rng.state)


func save_config() -> void:
	config.set_value("settings", "currency", currency)
	config.set_value("settings", "theme_index", theme_index)
	config.set_value("settings", "language", language)

	config.save("user://settings.cfg")
	print("config saved")


func _load_resources() -> void:
	if ResourceLoader.exists(save_states.get_active_path("world.tres")):
		print("loading user://leagues.tres")
		world = ResourceLoader.load(save_states.get_active_path("world.tres"))
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


func generate_leagues(p_generation_seed: String, p_generation_gender: Const.Gender) -> void:
	reset_seed(p_generation_seed, p_generation_gender)
	var generator: Generator = Generator.new()
	world = generator.generate_world()


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
	league = p_league
	team = p_team


func next_season() -> void:
	current_season += 1

	# TODO
	# teams go to upper/lower division
	# financial stuff
	# set new goals for manager
	# player contracts

	PlayerProgress.players_progress_season()
	
	for c: Continent in world.continents:
		for n: Nation in c.nations:
			for l: League in n.leagues.list:
				l.calendar.initialize(true)

			MatchMaker.inizialize_matches(n.leagues)

	Config.save_all_data()

	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


# shuffle array using global RuandomNumberGenerator
func shuffle(array: Array[Variant]) -> void:
	for i in array.size():
		var index: int = rng.randi_range(0, array.size() - 1)
		if index != i:
			var temp: Variant = array[index]
			array[index] = array[i]
			array[i] = temp

# shuffle array using global RuandomNumberGenerator
func pick_random(array: Array[Variant]) -> Variant:
	return array[rng.randi() % array.size() - 1]


# disable save, too heavy on close, breaks game
# save on quit on mobile
#func _notification(what: int) -> void:
#if what == NOTIFICATION_WM_CLOSE_REQUEST:
#save_all_data()
#get_tree().quit() # default behavior
