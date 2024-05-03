# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal language_change

func _on_english_pressed() -> void:
	Config.set_lang("en")
	language_change.emit()


func _on_portuguese_pressed() -> void:
	Config.set_lang("pt")
	language_change.emit()


func _on_italian_pressed() -> void:
	Config.set_lang("it")
	language_change.emit()


func _on_german_pressed() -> void:
	Config.set_lang("de")
	language_change.emit()


func _on_spanish_pressed() -> void:
	Config.set_lang("es")
	language_change.emit()

