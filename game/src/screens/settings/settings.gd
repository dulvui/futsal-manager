# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name Settings

@onready var theme_options:OptionButton = $VBoxContainer/Theme/ThemeOptionButton
@onready var version_label:Label = $VBoxContainer/Version/Version


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	for theme_name:String in ThemeUtil.get_theme_names():
		theme_options.add_item(theme_name)
	
	theme_options.selected = Config.theme_index
	
	version_label.text = Config.version

func _on_theme_option_button_item_selected(index: int) -> void:
	theme = ThemeUtil.set_active_theme(index)
	Config.save_config()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")
