# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

# meta-default: true
extends _BASE_


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	pass


func _process(delta: float) -> void:
	pass
