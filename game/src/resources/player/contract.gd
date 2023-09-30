# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name  Contract
extends Resource

@export var price:int
@export var money_week:int
# unixtimestamps
@export var start_date:int
@export var end_date:int
@export var bonus_goal:int
@export var bonus_clean_sheet:int
@export var bonus_assist:int
@export var bonus_league_title:int
@export var bonus_nat_cup_title:int
@export var bonus_inter_cup_title:int
@export var buy_clause:int
@export var is_on_loan:bool
