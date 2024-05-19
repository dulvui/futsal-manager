# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal email_action(message:EmailMessage)

@onready var message_list: Control = $Container/MessageList
@onready var message_container: Control = $Container/HBoxContainer/Message

func _ready() -> void:
	update_messages()
	message_container.show_message(EmailUtil.latest())
	
	EmailUtil.refresh_inbox.connect(update_messages)

func update_messages() -> void:
	message_list.update()

func show_offer_contract(content: Dictionary) -> void:
	emit_signal("offer_contract",content)

func _on_message_email_action(message:EmailMessage) -> void:
	email_action.emit(message)

func _on_message_list_show_message(message: EmailMessage) -> void:
	message_container.show_message(message)
	message.read = true
	update_messages()
