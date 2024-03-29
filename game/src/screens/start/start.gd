# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

#TODO
# - random name button

extends Control

@onready var nationality:OptionButton = $VBoxContainer/Manager/Container/Nat
@onready var m_name:LineEdit = $VBoxContainer/Manager/Container/Name
@onready var m_surname:LineEdit = $VBoxContainer/Manager/Container/SurName 

@onready var gender_option:OptionButton = $VBoxContainer/Settings/Container/Gender

@onready var seed_edit:LineEdit = $VBoxContainer/Seed/GridContainer/GeneratedSeedLineEdit

var generation_seed:String = Constants.DEFAULT_SEED

func _ready() -> void:
	for nation:String in Constants.Nations:
		nationality.add_item(nation)
		
	for gender:String in Constants.Gender:
		gender_option.add_item(gender)
	
	seed_edit.text = generation_seed

func _on_Back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_Continue_pressed() -> void:
	if m_name.text.length() * m_surname.text.length() * generation_seed.length() > 0:
		var manager:Manager =  Manager.new()
		manager.name = m_name.text
		manager.surname = m_surname.text
		manager.nationality = nationality.get_item_text(nationality.selected)
		Config.reset()
		Config.generate_leagues(generation_seed, gender_option.selected)
		Config.save_manager(manager)
		get_tree().change_scene_to_file("res://src/screens/team-select/team_select.tscn")


func _on_genearate_seed_button_pressed() -> void:
	generation_seed = str(randi_range(100000, 999999)) + "-" + str(randi_range(100000, 999999)) + "-" + str(randi_range(100000, 999999))
	seed_edit.text = generation_seed


func _on_default_seed_button_pressed() -> void:
	generation_seed = Constants.DEFAULT_SEED
	seed_edit.text = generation_seed
