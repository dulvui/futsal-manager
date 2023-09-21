# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Attributes

var goalkeeper:Goal
var mental:Mental
var tecnical:Tecnical
var physical:Physical


class Goal:
	var reflexes: int
	var positioning: int
	var kicking: int
	var handling: int
	var diving: int
	var speed: int

class Mental:
	var aggression:int
	var anticipation:int
	var decisions:int
	var concentration:int
	var teamwork:int
	var vision:int
	var work_rate:int
	var offensive_movement:int
	var marking:int
	
class Physical:
	var pace:int
	var acceleration:int
	var stamina:int
	var strength:int
	var agility:int
	var jump:int
	
class Tecnical:
	var crossing:int
	var passing:int
	var long_passing:int
	var tackling:int
	var heading:int
	var interception:int
	var shooting:int
	var long_shooting:int
	var penalty:int
	var finishing:int
	var dribbling:int
	var blocking:int
