# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


const THEME_FILE: StringName = "theme.tres"
const LABEL_SETTINGS: StringName = "label_settings.tres"
const LABEL_SETTINGS_BOLD: StringName = "label_settings_bold.tres"

const THEME_PATHS: Dictionary = {
	"DARK": "res://themes/default/",
	"LIGHT": "res://themes/light/",
}

var active_theme: Theme
var label_settings_bold: LabelSettings
var label_settings: LabelSettings


func _ready() -> void:
	set_active_theme(Global.theme_index)


func set_active_theme(index: int) -> Theme:
	Global.theme_index = index
	active_theme = ResourceLoader.load(_get_active_path(THEME_FILE), "Theme")
	label_settings = ResourceLoader.load(_get_active_path(LABEL_SETTINGS), "LabelSettings")
	label_settings_bold = ResourceLoader.load(_get_active_path(LABEL_SETTINGS_BOLD), "LabelSettings")
	return active_theme


func get_active_theme() -> Theme:
	return active_theme


func get_theme_names() -> Array:
	return THEME_PATHS.keys()


func reset_to_default() -> Theme:
	return set_active_theme(0)


func bold(label: Label) -> void:
	label.label_settings = label_settings_bold


func remove_bold(label: Label) -> void:
	label.label_settings = label_settings


func _get_active_path(file: String = "") -> StringName:
	print(file)
	return THEME_PATHS.values()[Global.theme_index] + file
