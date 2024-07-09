# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name TestMatchEngine
extends Node


func test() -> void:
	print("test: match engine...")
	
	var match_engine: MatchEngine = MatchEngine.new()
	
	print("test: match engine done.")
