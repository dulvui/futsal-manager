# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	# Tests.setup_mock_world(true)
	animation_player.play("Teaser")


