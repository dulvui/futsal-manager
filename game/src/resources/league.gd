# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name League
extends Resource

@export
var file_name:String 
var country:String
var id:int = 0
var name:int
var players_file_name:String
var teams:Array[Team]

func _init() -> void:
	print("init ", file_name)
	id += 1
	
