# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var thread: Thread


func save_world() -> void:
	if thread and thread.is_started():
		print("thread is already running")
		return
	thread = Thread.new()
	thread.start(_save_world, Thread.Priority.PRIORITY_HIGH)


func random_results() -> void:
	if thread and thread.is_started():
		print("thread is already running")
		return
	thread = Thread.new()
	thread.start(_random_results, Thread.Priority.PRIORITY_HIGH)


func _save_world() -> void:
	print("save world in thread...")
	ResUtil.save_resource("world", Global.world)
	call_deferred("_loading_done")


func _random_results() -> void:
	print("calculating random result in thread...")
	Global.world.random_results()
	call_deferred("_loading_done")


func _loading_done() -> void:
	LoadingUtil.done()
	thread.wait_to_finish()
	print("thread done.")


func _exit_tree() -> void:
	thread.wait_to_finish()