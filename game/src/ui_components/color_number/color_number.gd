# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ColorNumber
extends Label

# what number the label has
var key: String

func set_up(value: int) -> void:
	text = str(value)
	
	if not label_settings:
		label_settings = LabelSettings.new()
	
	if value < 11:
		label_settings.font_color = Color.RED
	elif value < 16:
		label_settings.font_color = Color.BLUE
	else:
		label_settings.font_color = Color.DARK_GREEN
