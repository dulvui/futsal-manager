# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const THEMES: Dictionary = {
	"DARK" : "res://themes/default/theme.tres",
	"LIGHT" : "res://themes/light/theme_light.tres",
}

var active_theme:Theme

func _ready() -> void:
	set_active_theme(Config.theme_index)


func set_active_theme(index: int) -> Theme:
	Config.theme_index = index
	active_theme = ResourceLoader.load(THEMES.values()[Config.theme_index], "Theme")
	return active_theme


func get_active_theme() -> Theme:
	return active_theme


func get_theme_names() -> Array:
	return THEMES.keys()


func reset_to_default() -> Theme:
	return set_active_theme(0)
