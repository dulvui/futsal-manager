# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Tournament
extends Resource

@export var id: int
@export var table: Table
@export var calendar: Calendar
@export var nation: Const.Nations
@export var pyramid_level: int
@export var name: String
@export var group_stage: String
