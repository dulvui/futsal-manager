# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name NameLabel
extends Control

@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect


func set_text(p_name: String) -> void:
	label.text = str(p_name)


func set_sub(is_true: bool) -> void:
	if is_true:
		color_rect.color = Color.SKY_BLUE


func set_line_up(is_true: bool) -> void:
	if is_true:
		color_rect.color = Color.PALE_GREEN
