# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal offer_contract

@onready var action_button:Button = $MessageContainer/VBoxContainer/BottomBar/Action

@onready var message:RichTextLabel = $MessageContainer/VBoxContainer/Message

func _ready() -> void:
	update_messages()
	$MessageContainer.hide()

func update_messages() -> void:
	for child in $ScrollContainer/Mails.get_children():
		child.queue_free()
	
	for i in range(EmailUtil.messages.size()-1,-1,-1): # reverse list
		var title_label:Label = Label.new()
		title_label.custom_minimum_size = Vector2(700, 0)
		title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		title_label.text = EmailUtil.messages[i]["title"]
		$ScrollContainer/Mails.add_child(title_label)
		
		var button:Button = Button.new()
		if EmailUtil.messages[i]["read"]:
			button.text = "READ"
		else:
			button.text = "*READ*"
		button.pressed.connect(show_message.bind(EmailUtil.messages[i]))
		$ScrollContainer/Mails.add_child(button)


func show_message(message_text:Dictionary) -> void:
	message_text["read"] = true
	action_button.hide()
	$MessageContainer/VBoxContainer/TopBar/SubjectText.text = message_text["title"]
	$MessageContainer/VBoxContainer/Details/Date.text = message_text["date"]
	$MessageContainer/VBoxContainer/Details/Sender.text = message_text["sender"]
	$MessageContainer.show()
	
	
	if message_text["type"] == EmailUtil.MessageTypes.CONTRACT_OFFER:
		action_button.text = tr("OFFER_CONTRACT")
		action_button.pressed.connect(show_offer_contract.bind(message_text["content"]))
		message.text = message_text["message"]
		action_button.show()
	elif message_text["type"] == EmailUtil.MessageTypes.CONTRACT_OFFER_MADE:
		message_text.text = "you made a conttract offer the player"
	#transfer
	else:
		message.text = message_text["message"]
		
	update_messages()


func show_offer_contract(content:Dictionary) -> void:
	emit_signal("offer_contract",content)

func _on_Action_pressed() -> void:
	pass # Replace with function body.


func _on_Close_pressed() -> void:
	$MessageContainer.hide()
