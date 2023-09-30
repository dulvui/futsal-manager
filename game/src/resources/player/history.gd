# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Statistics
extends Resource

@export var actual:Values
@export var history:Array

class History extends Resource:
	@export var year:int
	@export var values:Values

class Values extends Resource:
	@export var team_name:String
	@export var price:int
	@export var games_played:int
	@export var goals:int
	@export var assists:int
	@export var yellow_card:int
	@export var red_card:int
	@export var average_vote:float
	

