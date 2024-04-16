# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends ScrollContainer

@onready var vbox:VBoxContainer = $VBoxContainer

func append_text(text:String) -> void:
	var label:Label = Label.new()
	label.text = text
	vbox.add_child(label)
