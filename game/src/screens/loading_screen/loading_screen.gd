# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LoadingScreen
extends Control

@onready var loading_progress_bar: ProgressBar = $VBoxContainer/LoadingProgressBar


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func _process(_delta: float) -> void:
	if ResUtil.progress.size() > 0:
		loading_progress_bar.value = ResUtil.progress[0]
	
	if ResUtil.load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		loading_progress_bar.value = 1
		
		get_tree().change_scene_to_file.call_deferred("res://src/screens/dashboard/dashboard.tscn")
