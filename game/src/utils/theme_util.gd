# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


const THEMES_PATH: StringName = "res://themes/"
const BASE_PATH: StringName = "res://theme_base/"
const THEME_FILE: StringName = BASE_PATH + "theme.tres"

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

	var configuration: ThemeConfiguration = ResourceLoader.load(THEMES_PATH + theme_file)
	configuration.set_up()

	# labels
	theme.set_color("font_color", "Label", configuration.font_color)
	
	# rich text label
	theme.set_color("default_color", "RichTextLabel", configuration.font_color)
	
	# button colors
	theme.set_color("font_color", "Button", configuration.font_color)
	theme.set_color("font_color_hover", "Button", configuration.font_color_hover)
	theme.set_color("font_hover_color", "Button", configuration.font_color_hover)
	theme.set_color("font_color_pressed", "Button", configuration.font_color_pressed)
	theme.set_color("font_pressed_color", "Button", configuration.font_color_pressed)
	# button styles
	var button_normal: StyleBoxFlat = theme.get_stylebox("normal", "Button")
	button_normal.bg_color = configuration.button_color_normal
	var button_pressed: StyleBoxFlat = theme.get_stylebox("pressed", "Button")
	button_pressed.bg_color = configuration.button_color_pressed

	# link button
	theme.set_color("font_color", "LinkButton", configuration.font_color)
	theme.set_color("font_hover_color", "LinkButton", configuration.font_color_hover)
	
	# panel
	var panel: StyleBoxFlat = theme.get_stylebox("panel", "Panel")
	panel.bg_color = configuration.panel_color
