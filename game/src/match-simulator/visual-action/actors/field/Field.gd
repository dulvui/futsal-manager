# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D


@onready var width = int($Floor.texture.get_width() * scale.x)
@onready var height = int($Floor.texture.get_height() * scale.y)

