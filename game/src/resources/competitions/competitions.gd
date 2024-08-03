# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Competitions
extends Resource

@export var calendar: Calendar

@export var leagues: Leagues
@export var nation_cups: Array[Tournament]


# clubs
@export var world_cup: Tournament
@export var africa_cup: Tournament
@export var american_cup: Tournament
@export var asian_cup: Tournament
@export var european_cup: Tournament

# national
@export var national_world_cup: Tournament
@export var national_africa_cup: Tournament
@export var national_american_cup: Tournament
@export var national_asian_cup: Tournament
@export var national_european_cup: Tournament


# TODO club/national friendly matchs
