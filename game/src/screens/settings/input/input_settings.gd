# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InputSettings
extends VBoxContainer


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func restore_defaults() -> void:
	pass
