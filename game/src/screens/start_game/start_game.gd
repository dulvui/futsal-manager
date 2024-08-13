# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

#TODO
# - random name button

extends Control

const DEFAULT_SEED: String = "SuchDefaultSeed"

@onready var nations: OptionButton = $VBoxContainer/Manager/Container/Nat
@onready var m_name: LineEdit = $VBoxContainer/Manager/Container/Name
@onready var m_surname: LineEdit = $VBoxContainer/Manager/Container/SurName

@onready var gender_option: OptionButton = $VBoxContainer/Settings/Container/Gender
@onready var start_year_spinbox: SpinBox = $VBoxContainer/Settings/Container/StartYear

@onready var seed_edit: LineEdit = $VBoxContainer/Seed/GridContainer/GeneratedSeedLineEdit

var generation_seed: String = DEFAULT_SEED


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	Config.save_states.new_temp_state()
	Config.load_save_state()

	for nation: Nation in Config.world.get_all_nations():
		nations.add_item(nation.name)

	for gender: String in Const.Gender:
		gender_option.add_item(gender)

	seed_edit.text = generation_seed
	start_year_spinbox.get_line_edit().text = str(Config.start_date.year)


func _on_generated_seed_line_edit_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		generation_seed = new_text


func _on_genearate_seed_button_pressed() -> void:
	generation_seed = (
		str(randi_range(100000, 999999))
		+ "-"
		+ str(randi_range(100000, 999999))
		+ "-"
		+ str(randi_range(100000, 999999))
	)
	seed_edit.text = generation_seed


func _on_default_seed_button_pressed() -> void:
	generation_seed = DEFAULT_SEED
	seed_edit.text = generation_seed


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_continue_pressed() -> void:
	if m_name.text.length() * m_surname.text.length() * generation_seed.length() > 0:
		var manager: Manager = Manager.new()
		manager.name = m_name.text
		manager.surname = m_surname.text
		manager.nation = Config.world.get_all_nations()[nations.selected].name

		# start date in fomrat YYYY-MM-DDTHH:MM:SS
		var start_year: String = start_year_spinbox.get_line_edit().text
		var start_date_str: String = (
			"%s-%02d-%02dT00:00:00" % [start_year, Const.SEASON_START_MONTH, Const.SEASON_START_DAY]
		)
		Config.start_date = Time.get_datetime_dict_from_datetime_string(start_date_str, true)

		Config.generate_leagues(generation_seed, gender_option.selected)
		Config.manager = manager
		get_tree().change_scene_to_file("res://src/screens/team_select/team_select.tscn")

