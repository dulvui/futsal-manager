# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveStateScreen
extends Control

const SaveStateEntryScene: PackedScene = preload(
	"res://src/screens/save_states_screen/save_state_entry/save_state_entry.tscn"
)

@onready var entry_list: VBoxContainer = $VBoxContainer/ScrollContainer/EntryList
@onready var loading_screen: LoadingScreen = $LoadingScreen
@onready
var active_save_state_entry: SaveStateEntry = $VBoxContainer/ScrollContainer/EntryList/ActiveSaveState


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	var active_save_state: SaveState = Global.save_states.get_active()
	active_save_state_entry.set_up(active_save_state)
	active_save_state_entry.load_game.connect(func() -> void: loading_screen.show())

	for save_state: SaveState in Global.save_states.list:
		if save_state.id != active_save_state.id:
			var entry: SaveStateEntry = SaveStateEntryScene.instantiate()
			entry_list.add_child(entry)
			entry.set_up(save_state)
			entry.load_game.connect(func() -> void: loading_screen.show())


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_loading_screen_loaded(_type: LoadingUtil.Type) -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
