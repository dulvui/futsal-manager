# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var subject:Label = $VBoxContainer/TopBar/SubjectText
@onready var sender:Label = $VBoxContainer/Details/Sender
@onready var date:Label = $VBoxContainer/Details/Date
@onready var text:RichTextLabel = $VBoxContainer/Message

func show_message(message:EmailMessage) -> void:
	subject.text = message.subject
	sender.text = message.sender
	date.text = message.date
	text.text = message.text
