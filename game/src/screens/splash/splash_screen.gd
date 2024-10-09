# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var loading_progress_bar: ProgressBar = $LoadingProgressBar


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()


func _process(_delta: float) -> void:
	if ResUtil.progress.size() > 0:
		loading_progress_bar.value = ResUtil.progress[0]
	
	if ResUtil.load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		loading_progress_bar.value = 1
		
		if Config.language:
			get_tree().change_scene_to_file.call_deferred("res://src/screens/menu/menu.tscn")
		else:
			get_tree().change_scene_to_file.call_deferred(
				"res://src/screens/setup_language/setup_language.tscn"
			)
