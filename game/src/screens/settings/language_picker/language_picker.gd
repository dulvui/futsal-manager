# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal language_change

@onready var en: TextureButton = $HBoxContainer/English
@onready var pt: TextureButton = $HBoxContainer/Portuguese
@onready var it: TextureButton = $HBoxContainer/Italian
@onready var es: TextureButton = $HBoxContainer/Spanish
@onready var de: TextureButton = $HBoxContainer/German


func _ready() -> void:
	activate_lang_button()


func activate_lang_button() -> void:
	if Global.language:
		en.modulate.a = 0.6
		pt.modulate.a = 0.6
		es.modulate.a = 0.6
		de.modulate.a = 0.6
		it.modulate.a = 0.6

		match Global.language:
			"en":
				en.modulate.a = 1
			"pt":
				pt.modulate.a = 1
			"es":
				es.modulate.a = 1
			"de":
				de.modulate.a = 1
			"it":
				it.modulate.a = 1


func _on_english_pressed() -> void:
	Global.set_lang("en")
	activate_lang_button()
	language_change.emit()


func _on_portuguese_pressed() -> void:
	Global.set_lang("pt")
	activate_lang_button()
	language_change.emit()


func _on_italian_pressed() -> void:
	Global.set_lang("it")
	activate_lang_button()
	language_change.emit()


func _on_german_pressed() -> void:
	Global.set_lang("de")
	activate_lang_button()
	language_change.emit()


func _on_spanish_pressed() -> void:
	Global.set_lang("es")
	activate_lang_button()
	language_change.emit()
