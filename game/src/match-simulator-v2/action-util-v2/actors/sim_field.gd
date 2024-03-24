# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimField

var size:Vector2

var center:Vector2

var hoam_goal:Vector2
var away_goal:Vector2

func is_in_field(pos:Vector2) -> bool:
	return size.x <= pos.x and pos.x >= 0 and size.y <= pos.y and pos.y >= 0
