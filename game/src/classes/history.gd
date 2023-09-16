# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Statistics
extends Resource

var actual:Values
var history:Array

class Values:
	var team_name:String
	var price:int
	var games_played:int
	var goals:int
	var assists:int
	var yellow_card:int
	var red_card:int
	var average_vote:float
	
class History:
	var year:int
	var values:Values
