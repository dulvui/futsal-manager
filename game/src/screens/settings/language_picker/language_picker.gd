# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends HBoxContainer

signal language_change

@onready var en: Button = $English
@onready var pt: Button = $Portuguese
@onready var it: Button = $Italian
@onready var es: Button = $Spanish
@onready var de: Button = $German


func _ready() -> void:
	# toggle active language
	en.button_pressed = Global.language == "en" 
	pt.button_pressed = Global.language == "pt" 
	it.button_pressed = Global.language == "it" 
	es.button_pressed = Global.language == "es" 
	de.button_pressed = Global.language == "de" 

	print(Global.language)


func _on_english_pressed() -> void:
	Global.set_lang("en")
	language_change.emit()


func _on_portuguese_pressed() -> void:
	Global.set_lang("pt")
	language_change.emit()


func _on_italian_pressed() -> void:
	Global.set_lang("it")
	language_change.emit()


func _on_german_pressed() -> void:
	Global.set_lang("de")
	language_change.emit()


func _on_spanish_pressed() -> void:
	Global.set_lang("es")
	language_change.emit()
