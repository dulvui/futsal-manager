# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


const BASE_PATH: StringName = "res://theme/"
const THEME_FILE: StringName = BASE_PATH + "theme.tres"
const CONFIG_PATH: StringName = BASE_PATH + "configurations/"

const LABEL_SETTINGS_FILE: StringName = BASE_PATH + "label/label_settings.tres"
const LABEL_SETTINGS_BOLD_FILE: StringName = BASE_PATH + "label/label_settings_bold.tres"

const THEMES: Dictionary = {
	"DARK" : "theme_dark.tres", 
	"LIGHT" : "theme_light.tres", 
	"SOLARIZED_LIGHT" : "theme_solarized_light.tres", 
}

var theme: Theme
var label_settings_bold: LabelSettings
var label_settings: LabelSettings


func _ready() -> void:
	theme = ResourceLoader.load(THEME_FILE, "Theme")
	label_settings = ResourceLoader.load(LABEL_SETTINGS_FILE, "LabelSettings")
	label_settings_bold = ResourceLoader.load(LABEL_SETTINGS_BOLD_FILE, "LabelSettings")
	_apply_configuration(Global.theme_index)


func get_active_theme() -> Theme:
	return theme


func set_theme(index: int) -> Theme:
	_apply_configuration(index)
	return theme


func get_theme_names() -> Array:
	return THEMES.keys()


func reset_to_default() -> Theme:
	return set_theme(0)


func bold(label: Label) -> void:
	label.label_settings = label_settings_bold


func remove_bold(label: Label) -> void:
	label.label_settings = label_settings


func _apply_configuration(index: int) -> void:
	var theme_name: StringName = THEMES.keys()[index]
	var theme_file: StringName = THEMES[theme_name]

	var configuration: ThemeConfiguration = ResourceLoader.load(CONFIG_PATH + theme_file)

	# labels
	theme.set_color("font_color", "Label", configuration.font_color)
	
	# rich text label
	theme.set_color("default_font_color", "RichTextLabel", configuration.font_color)
	
	# button colors
	theme.set_color("font_color", "Button", configuration.button.font_color)
	theme.set_color("font_color_hover", "Button", configuration.button.font_color)
	theme.set_color("font_hover_color", "Button", configuration.button.font_color)
	theme.set_color("font_color_pressed", "Button", configuration.button.font_color)
	theme.set_color("font_pressed_color", "Button", configuration.button.font_color)
	# button styles
	var button_normal: StyleBoxFlat = theme.get_stylebox("normal", "Button")
	button_normal.bg_color = configuration.button.normal_bg_color
	var button_pressed: StyleBoxFlat = theme.get_stylebox("pressed", "Button")
	button_pressed.bg_color = configuration.button.pressed_bg_color
	
	# link button
	theme.set_color("font_color", "LinkButton", configuration.button.font_color)
	theme.set_color("font_hover_color", "LinkButton", configuration.button.font_color)
	
	# panel
	var panel: StyleBoxFlat = theme.get_stylebox("panel", "Panel")
	panel.bg_color = configuration.panel_color
