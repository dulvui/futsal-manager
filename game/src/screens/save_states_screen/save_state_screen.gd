# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name  SaveStateScreen

const SaveStateEntryScene: PackedScene = preload("res://src/screens/save_states_screen/save_state_entry/save_state_entry.tscn")
@onready var entry_list: VBoxContainer = $ScrollContainer/EntryList


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	for save_state:SaveState in Config.save_states.list:
		var entry: SaveStateEntry = SaveStateEntryScene.instantiate()
		entry.set_up(save_state)
		entry_list.add_child(entry)


