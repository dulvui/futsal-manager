# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name DefaultConfirmDialog
extends PopupPanel

signal cancel
signal confirm

@export var custom_title: String = ""
@export_multiline var custom_text: String = ""

@onready var rich_text_label: RichTextLabel = %Text
@onready var title_label: Label = %Title


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	hide()

	rich_text_label.text = custom_text
	title_label.text = custom_title



func _on_accept_pressed() -> void:
	confirm.emit()
	hide()


func _on_cancel_pressed() -> void:
	cancel.emit()
	hide()

