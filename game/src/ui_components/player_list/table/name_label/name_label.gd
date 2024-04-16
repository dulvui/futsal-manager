# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

func set_text(p_name:String) -> void:
	$Label.text = str(p_name)
	
func set_sub(is_true:bool) -> void:
	if is_true:
		$ColorRect.color = Color.SKY_BLUE
	
func set_line_up(is_true:bool) -> void:
	if is_true:
		$ColorRect.color = Color.PALE_GREEN
