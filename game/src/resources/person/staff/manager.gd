# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Manager
extends Person

@export var agent: Agent

func _init(
	p_agent: Agent = Agent.new(),
) -> void:
	super(Person.Role.MANAGER)
	agent = p_agent
