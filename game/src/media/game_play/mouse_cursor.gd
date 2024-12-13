# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Sprite2D


func _process(_delta: float) -> void:
    position = get_viewport().get_mouse_position()
