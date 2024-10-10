# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Settings
extends Control

const RESOLUTIONS: Dictionary = {
	"3840x2160": Vector2i(3840, 2160),
	"2560x1440": Vector2i(2560, 1080),
	"1920x1080": Vector2i(1920, 1080),
	"1366x768": Vector2i(1366, 768),
	"1536x864": Vector2i(1536, 864),
	"1280x720": Vector2i(1280, 720),
	"1440x900": Vector2i(1440, 900),
	"1600x900": Vector2i(1600, 900),
	"1024x600": Vector2i(1024, 600),
	"800x600": Vector2i(800, 600)
}

@onready var theme_options: OptionButton = $VBoxContainer/Theme/ThemeOptionButton
@onready var resolution_options: OptionButton = $VBoxContainer/Resolution/ResolutionOptionButton

@onready var version_label: Label = $VBoxContainer/Version/VersionLabel


func _ready() -> void:
	# theme
	theme = ThemeUtil.get_active_theme()
	for theme_name: String in ThemeUtil.get_theme_names():
		theme_options.add_item(theme_name)
	theme_options.selected = Global.theme_index

	# resolutions
	for resolution: String in RESOLUTIONS.keys():
		resolution_options.add_item(resolution)
	resolution_options.selected = 0

	version_label.text = Global.version


func _on_theme_option_button_item_selected(index: int) -> void:
	theme = ThemeUtil.set_active_theme(index)
	Global.save_config()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_resolution_option_button_item_selected(index: int) -> void:
	size = RESOLUTIONS[RESOLUTIONS.keys()[index]]


func _on_defaults_pressed() -> void:
	# theme
	theme = ThemeUtil.reset_to_default()
	# save
	Global.save_config()
