# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


@onready var version: Label = %Version
@onready var content: PanelContainer = %Content

var previous_scenes: Array[String]


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	previous_scenes = []
	version.text = "v" + Global.version


func change_scene(scene_path: String) -> void:
	for child: Node in content.get_children():
		content.remove_child(child)
		child.queue_free()
	
	_append_scene_to_buffer(scene_path)
	
	var scene: PackedScene = load(scene_path)
	content.add_child(scene.instantiate())


func previous_scene() -> void:
	if previous_scenes.size() > 1:
		change_scene(previous_scenes[-2])
	else:
		print("not valid previous scene found")


func _append_scene_to_buffer(scene_path: String) -> void:
	previous_scenes.append(scene_path)
	if previous_scenes.size() > 5:
		previous_scenes.remove_at(0)
