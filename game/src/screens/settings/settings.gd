# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name Settings

@onready var theme_options:OptionButton = $VBoxContainer/Theme/ThemeOptionButton


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	for theme_name:String in ThemeUtil.get_theme_names():
		theme_options.add_item(theme_name)


func _on_theme_option_button_item_selected(index: int) -> void:
	theme = ThemeUtil.set_active_theme(index)
	Config.save_config()
