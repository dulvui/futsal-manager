# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal email_action(message:EmailMessage)

@onready var mails:GridContainer = $SplitContainer/ScrollContainer/Mails
@onready var message_container:Control = $SplitContainer/Message

func _ready() -> void:
	update_messages()
	show_message(EmailUtil.latest())
	
	EmailUtil.refresh_inbox.connect(update_messages)

func update_messages() -> void:
	for child in mails.get_children():
		child.queue_free()
	
	for i in range(EmailUtil.messages.size()-1,-1,-1): # reverse list
		var button:Button = Button.new()
		if EmailUtil.messages[i].read:
			button.text = "READ"
		else:
			button.text = "*READ*"
		button.pressed.connect(show_message.bind(EmailUtil.messages[i]))
		mails.add_child(button)
		
		var title_label:Label = Label.new()
		title_label.custom_minimum_size = Vector2(300, 0)
		title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		title_label.text = EmailUtil.messages[i].subject
		mails.add_child(title_label)


func show_message(message:EmailMessage) -> void:
	message_container.show_message(message)
	message.read = true
	update_messages()

func show_offer_contract(content:Dictionary) -> void:
	emit_signal("offer_contract",content)

func _on_message_email_action(message:EmailMessage) -> void:
	email_action.emit(message)
