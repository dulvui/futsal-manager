# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualEmail
extends VBoxContainer

signal email_action(message: EmailMessage)

@onready var message_list: VisualEmailMessageList = $HSplitContainer/MessageList
@onready var message_container: VisualEmailMessage = $HSplitContainer/MessageView/Message


func _ready() -> void:
	update_messages()
	message_container.show_message(EmailUtil.latest())

	EmailUtil.refresh_inbox.connect(update_messages)


func update_messages() -> void:
	message_list.update()


func show_offer_contract(content: Dictionary) -> void:
	emit_signal("offer_contract", content)


func _on_message_email_action(message: EmailMessage) -> void:
	email_action.emit(message)


func _on_message_list_show_message(message: EmailMessage) -> void:
	message_container.show_message(message)
	update_messages()


func _on_search_text_changed(new_text: String) -> void:
	message_list.search(new_text)


func _on_only_unread_toggled(toggled_on: bool) -> void:
	message_list.unread(toggled_on)


func _on_starred_toggled(toggled_on: bool) -> void:
	message_list.starred(toggled_on)
