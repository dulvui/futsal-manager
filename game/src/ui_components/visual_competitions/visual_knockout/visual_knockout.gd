# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualKnockout
extends HBoxContainer


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	Tests.setup_mock_world(true)


func set_up(knockout: Knockout) -> void:
	print(knockout)
