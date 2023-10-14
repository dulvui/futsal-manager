# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name LineUp

# Formations {"2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"}
enum Formations { F22, F121, F112, F211, F13, F31, F40 }

@export var formation:Formations
@export var goalkeeper:Goalkeeper
@export var players:Array[Player]
@export var subsitutions:Array[Player]


