# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LoadingScreen
extends Control

signal loaded

@onready var loading_progress_bar: ProgressBar = $VBoxContainer/LoadingProgressBar
@onready var message_label: Label = $VBoxContainer/Message


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	loading_progress_bar.indeterminate = LoadingUtil.indeterminate
	# connect loaded signal also here
	LoadingUtil.loaded.connect(func() -> void: loaded.emit())


func _process(_delta: float) -> void:
	if not LoadingUtil.indeterminate:
		message_label.text = LoadingUtil.message
		loading_progress_bar.value = LoadingUtil.progress
