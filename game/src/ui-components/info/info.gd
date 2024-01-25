# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var generation_seed:Label = $VBoxContainer/HBoxContainer/GenerationSeed

func _ready() -> void:
	generation_seed.text = Config.generation_seed
