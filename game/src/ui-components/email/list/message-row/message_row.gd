# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name MessageRow

signal click()

# player row button colors
const COLOR_FOCUS:Color = Color(1,1,1,0.2)
const COLOR_NORMAL:Color = Color(1,1,1,0)

@onready var button:Button = $Button
@onready var subject_label:Label = $HBoxContainer/Subject
@onready var sender_label:Label = $HBoxContainer/Sender
@onready var date_label:Label = $HBoxContainer/Date


func set_up(message:EmailMessage) -> void:
	button.tooltip_text = tr("Click to read message")
	
	subject_label.set_text(message.subject)
	sender_label.set_text(message.sender)
	date_label.set_text(message.date)
	
	if not message.read:
		var bold:LabelSettings = LabelSettings.new()
		bold.font_size = get_theme_default_font_size()
		bold.outline_size = 2
		# make bold
		subject_label.label_settings = bold
		sender_label.label_settings = bold
		date_label.label_settings = bold
		
		

func _on_button_button_down() -> void:
	click.emit()

func _on_button_mouse_entered() -> void:
	button.self_modulate = COLOR_FOCUS

func _on_button_mouse_exited() -> void:
	button.self_modulate = COLOR_NORMAL
