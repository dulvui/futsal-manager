# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal loaded

var message: String
var progress: float
var indeterminate: bool


func start(p_message: String, p_indeterminate: bool = false) -> void:
	indeterminate = p_indeterminate
	message = p_message
	progress = 0


func update(p_progress: float) -> void:
	progress = p_progress


func done() -> void:
	loaded.emit()
