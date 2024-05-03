# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const default:String = "res://themes/default/theme.tres"
const themes_names:Array[String] = [
	default,
	"res://themes/light/theme_light.tres",
]

var themes:Dictionary
var active_theme:Theme

func _ready() -> void:
	set_active_theme(Config.theme)


func set_active_theme(path:String) -> void:
	active_theme = ResourceLoader.load(path, "Theme")


func get_active_theme() -> Theme:
	if not active_theme:
		set_active_theme(Config.theme)
	return active_theme
