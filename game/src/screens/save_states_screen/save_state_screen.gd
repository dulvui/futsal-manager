# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveStateScreen
extends Control

const SaveStateEntryScene: PackedScene = preload(
	"res://src/screens/save_states_screen/save_state_entry/save_state_entry.tscn"
)
@onready var entry_list: VBoxContainer = $VBoxContainer/ScrollContainer/EntryList


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	for save_state: SaveState in Global.save_states.list:
		var entry: SaveStateEntry = SaveStateEntryScene.instantiate()
		entry_list.add_child(entry)
		entry.set_up(save_state)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")
