# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualEmailMessage
extends Control

signal email_action(message: EmailMessage)

var message: EmailMessage

@onready var subject: Label = $MarginContainer/VBoxContainer/TopBar/SubjectText
@onready var sender: Label = $MarginContainer/VBoxContainer/Details/Sender
@onready var date: Label = $MarginContainer/VBoxContainer/Details/Date
@onready var text: RichTextLabel = $MarginContainer/VBoxContainer/Message
@onready var action_button: Button = $MarginContainer/VBoxContainer/BottomBar/Action


func show_message(p_message: EmailMessage) -> void:
	message = p_message
	message.read = true
	subject.text = message.subject
	sender.text = message.sender
	date.text = message.date
	text.text = message.text

	if message.type == EmailMessage.Type.CONTRACT_OFFER:
		action_button.show()
		action_button.text = "OFFER_CONTARCT"
	else:
		action_button.hide()


func _on_action_pressed() -> void:
	email_action.emit(message)
