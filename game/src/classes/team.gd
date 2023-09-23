# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Team
extends Resource

# replace with enum
var formations:Array = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]

var id:int
var name:String
var stadium:Stadium
var formation:int
var prestige:int
var budget:int
var salary_budget:int
var players:Dictionary

class Stadium:
	var name:String
	var capacity:int
	var year_built:int
