# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

#TODO
# - random name button

extends Control

@onready var nationality:OptionButton = $VBoxContainer/Manager/GridContainer/Nat
@onready var m_name:LineEdit = $VBoxContainer/Manager/GridContainer/Name
@onready var m_surname:LineEdit = $VBoxContainer/Manager/GridContainer/SurName 

@onready var seed_container:VBoxContainer = $VBoxContainer/Seed
@onready var seed_edit:LineEdit = $VBoxContainer/Seed/GridContainer/GeneratedSeedLineEdit

var generation_seed:String = Constants.DEFAULT_SEED

func _ready() -> void:
	# TODO add all possible nationalities
	for nation:String in Constants.Nations:
		nationality.add_item(nation)
	
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
		Config.generate_leagues(generation_seed)
		Config.save_manager(manager)
		get_tree().change_scene_to_file("res://src/screens/team-select/team_select.tscn")


func _on_genearate_seed_button_pressed() -> void:
	generation_seed = str(randi()) + "-" + str(randi()) + "-" + str(randi())
	seed_edit.text = generation_seed


func _on_advanced_pressed() -> void:
	seed_container.visible = not seed_container.visible
	
	if not seed_container.visible:
		generation_seed = Constants.DEFAULT_SEED
		seed_edit.text = generation_seed
