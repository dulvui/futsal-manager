# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Player
extends Resource

enum Position {P, D, C, A}
enum Foot {L, R}
enum Form {Bad, Good, Excellent}

@export var id:int
#var team:Team
@export var price:int
# shirt number
@export var nr:int
@export var name:String
@export var surname:String
@export var birth_date:String
@export var nationality:String
@export var moral = 4
@export var position:Position
@export var foot:Foot
@export var prestige:int
@export var form:Form
@export var potential_growth:int
@export var injury_potential:int
@export var loyality:int
@export var contract:Contract
@export var statistics:Statistics
@export var attributes:Attributes

