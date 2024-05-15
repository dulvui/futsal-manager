# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Control

var bold_label_settings:LabelSettings = load("res://themes/bold_label_settings.tres")
var label_settings:LabelSettings = load("res://themes/label_settings.tres")


func bold(label:Label) -> void:
	label.label_settings = bold_label_settings


func remove_bold(label:Label) -> void:
	label.label_settings = label_settings
