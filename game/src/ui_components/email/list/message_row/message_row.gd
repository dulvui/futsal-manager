# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MessageRow
extends Control

signal click

# player row button colors
const COLOR_FOCUS: Color = Color(1, 1, 1, 0.2)
const COLOR_NORMAL: Color = Color(1, 1, 1, 0)

var message: EmailMessage

@onready var button: Button = $Button
@onready var subject_label: Label = $Button/HBoxContainer/Subject
@onready var sender_label: Label = $Button/HBoxContainer/Sender
@onready var date_label: Label = $Button/HBoxContainer/Date
@onready var star: CheckBox = $Button/HBoxContainer/Star


func set_up(p_message: EmailMessage) -> void:
	message = p_message

	button.tooltip_text = tr("Click to read message")

	subject_label.set_text(message.subject)
	sender_label.set_text(message.sender)
	date_label.set_text(message.date)
	star.button_pressed = message.starred

	if not message.read:
		# make bold
		UiUtil.bold(subject_label)
		UiUtil.bold(sender_label)
		UiUtil.bold(date_label)


func _on_button_button_down() -> void:
	click.emit()


func _on_button_mouse_entered() -> void:
	button.self_modulate = COLOR_FOCUS


func _on_button_mouse_exited() -> void:
	button.self_modulate = COLOR_NORMAL


func _on_star_toggled(toggled_on: bool) -> void:
	message.starred = toggled_on
