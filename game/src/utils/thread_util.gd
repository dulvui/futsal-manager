# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


var thread: Thread


func _ready() -> void:
	thread = Thread.new()


func save_world() -> void:
	# save world with thread
	if thread.is_started():
		print("save world thread is already saving")
		return
	
	thread.start(_save_world, Thread.Priority.PRIORITY_HIGH)


func _save_world() -> void:
	print("save world in thread...")
	ResUtil.save_resource("world", Global.world)
	call_deferred("_on_world_saved")


func _on_world_saved() -> void:
	LoadingUtil.done()
	print("save world in thread done.")


func _exit_tree() -> void:
	thread.wait_to_finish()
