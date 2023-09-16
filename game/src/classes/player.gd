# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Player
extends Resource

enum Position {P, D, C, A}
enum Foot {L, R}
enum Form {Bad, Good, Excellent}

var id:int
var team:Team
var price:int
# shirt nu,ber
var nr:int
var name:String
var surname:String
var birth_date:String
var nationality:String
var moral = 4
var position:Position
var foot:Foot
var prestige:int
var form:Form
var _potential_growth:int
var _injury_potential:int
var _loyality:int
var contract:Contract
var statistics:Statistics
var attributes:Attributes

