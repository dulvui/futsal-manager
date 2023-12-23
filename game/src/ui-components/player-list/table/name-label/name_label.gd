# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

func set_text(name:String, in_line_up:bool = false) -> void:
	if in_line_up:
		$ColorRect.color = Color.FIREBRICK
	$Label.text = str(name)
