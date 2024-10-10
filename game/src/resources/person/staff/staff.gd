# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Staff
extends JSONResource


@export var president: President
@export var scout: Scout
@export var manager: Manager


func _init(
	p_president: President = President.new(),
	p_scout: Scout = Scout.new(),
	p_manager: Manager = Manager.new(),
) -> void:
	president = p_president
	scout = p_scout
	manager = p_manager
