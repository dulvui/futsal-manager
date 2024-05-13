# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal load
signal delete


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func set_up() -> void:
	pass
