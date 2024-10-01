# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

#TODO
# - random name button

extends Control

const DEFAULT_SEED: String = "SuchDefaultSeed"

@onready var nations: OptionButton = $VBoxContainer/Manager/Container/Nat
@onready var manager_name: LineEdit = $VBoxContainer/Manager/Container/Name
@onready var manager_surname: LineEdit = $VBoxContainer/Manager/Container/SurName


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	# reset temp values
	if Config.manager:
		manager_name.text = Config.manager.name
		manager_surname.text = Config.manager.surname

	for nation: Nation in Config.world.get_all_nations():
		nations.add_item(nation.name)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/setup/setup_world/setup_world.tscn")


func _on_continue_pressed() -> void:
	if manager_name.text.length() * manager_surname.text.length() > 0:
		var manager: Manager = Manager.new()
		manager.name = manager_name.text
		manager.surname = manager_surname.text
		manager.nation = Config.world.get_all_nations()[nations.selected].name
		Config.manager = manager
		
		get_tree().change_scene_to_file("res://src/screens/setup/setup_team/setup_team.tscn")
