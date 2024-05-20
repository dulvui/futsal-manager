# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Inbox
extends Resource

@export var list: Array[EmailMessage]

func _init(
	p_list: Array[EmailMessage] = [],
	) -> void:
	list = p_list

