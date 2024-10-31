# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var config_version: StringName = "1"
var version: StringName = ProjectSettings.get_setting("application/config/version")

# config
var config: ConfigFile

# vars
var language: String
var currency: int
var theme_index: int
var theme_font_size: int
var theme_custom_font_color: Color
var theme_custom_style_color: Color
var theme_custom_background_color: Color
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

# saves match pause state
var match_paused: bool

# resources
var world: World
var transfers: Transfers
var inbox: Inbox
# active resources references, from world
var team: Team
var league: League
var manager: Manager

# save states
var save_states: SaveStates


func _ready() -> void:
	print("version " + Global.version)
	speed_factor = 1
	_load_config()
	save_states = ResUtil.load_save_states()
	set_lang(language)
	RngUtil.set_up_rngs()


func select_team(p_league: League, p_team: Team) -> void:
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

	speed_factor = save_states.temp_state.speed_factor
	start_date = save_states.temp_state.start_date

	save_states.make_temp_active()


func next_day() -> void:
	world.calendar.next_day()

	if world.calendar.is_match_day():
		EmailUtil.next_match(world.calendar.get_next_match())

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
	save_all_data()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func save_config() -> void:
	config.set_value("settings", "currency", currency)
	config.set_value("settings", "language", language)
	config.set_value("settings", "theme_index", theme_index)
	config.set_value("settings", "theme_font_size", theme_font_size)
	config.set_value("settings", "theme_custom_font_color", theme_custom_font_color)
	config.set_value("settings", "theme_custom_style_color", theme_custom_style_color)
	config.set_value("settings", "theme_custom_background_color", theme_custom_background_color)

	config.save("user://settings.cfg")

	BackupUtil.create_backup("user://settings", ".cfg")


func save_all_data() -> void:
	ResUtil.save_save_states()
	save_config()


func set_lang(lang: String) -> void:
	TranslationServer.set_locale(lang)
	language = lang
	save_config()


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
		LoadingUtil.done()


func _load_config() -> void:
	config = ConfigFile.new()
	var err: int = config.load("user://settings.cfg")
	# if not, something went wrong with the file loading
	if err != OK:
		print("error loading user://settings.cfg")
		BackupUtil.restore_backup("user://settings", ".cfg")
		err = config.load("user://settings.cfg")
		if err != OK:
			print("error restoring backup for user://settings.cfg")

	currency = config.get_value("settings", "currency", FormatUtil.Currencies.EURO)
	language = config.get_value("settings", "language", "")
	theme_index = config.get_value("settings", "theme_index", 0)
	theme_font_size = config.get_value("settings", "theme_font_size", Const.FONT_SIZE_DEFAULT)
	theme_custom_font_color = config.get_value("settings", "theme_custom_font_color", Color.BLACK)
	theme_custom_style_color = config.get_value("settings", "theme_custom_style_color", Color.RED)
	theme_custom_background_color = config.get_value("settings", "theme_custom_background_color", Color.WHITE)

