# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name Settings

enum Themes { DARK , LIGHT }

@onready var theme_options:OptionButton = $VBoxContainer/Theme/ThemeOptionButton


func _ready() -> void:
	for themes:String in Themes.keys():
		theme_options.add_item(themes)
	


func _on_theme_option_button_item_selected(_index: int) -> void:
	#Config.themes = Themes.get(index)
	pass
	
