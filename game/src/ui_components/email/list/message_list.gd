# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualEmailMessageList
extends Control

signal show_message(message: EmailMessage)

const MessageRowScene: PackedScene = preload(
	"res://src/ui_components/email/list/message_row/message_row.tscn"
)

var search_text: String = ""
var only_starred: bool = false
var only_unread: bool = false

@onready var list: VBoxContainer = $ScrollContainer/List


func update() -> void:
	for child in list.get_children():
		child.queue_free()
	print("UPDATE")

	var inbox_list: Array[EmailMessage] = Global.inbox.list

	if only_starred:
		inbox_list = inbox_list.filter(func(m: EmailMessage) -> bool: return m.starred)
	if only_unread:
		inbox_list = inbox_list.filter(func(m: EmailMessage) -> bool: return not m.read)
	if search_text.length() > 0:
		inbox_list = inbox_list.filter(
			func(m: EmailMessage) -> bool: return (
				(m.text.to_lower() + m.subject.to_lower() + m.sender.to_lower())
				. contains(search_text.to_lower())
			)
		)

	# to test perfomrance of email view
	#for j in range(1000):
	for i in range(inbox_list.size() - 1, -1, -1):  # reverse list
		var message: EmailMessage = inbox_list[i]

		var row: MessageRow = MessageRowScene.instantiate()
		list.add_child(row)
		row.read_button.pressed.connect(_on_row_pressed.bind(message))
		row.set_up(message)

		if i > 0:
			list.add_child(HSeparator.new())


func starred(p_only_starred: bool) -> void:
	only_starred = p_only_starred
	update()


func unread(p_only_unread: bool) -> void:
	only_unread = p_only_unread
	update()


func search(text: String) -> void:
	search_text = text
	update()


func _on_row_pressed(message: EmailMessage) -> void:
	show_message.emit(message)
