# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TeamProfile
extends HBoxContainer

@onready var player_list: PlayerList = $PlayerList
@onready var name_label: Label = $TeamInfo/Name
@onready var prestige_stars_label: Label = $TeamInfo/PresitgeStars
@onready var prestige_label: Label = $TeamInfo/Presitge
@onready var budget_label: Label = $TeamInfo/Budget
@onready var salary_budget_label: Label = $TeamInfo/SalaryBudget
@onready var stadium_name_label: Label = $TeamInfo/StadiumName
@onready var stadium_capacity_label: Label = $TeamInfo/StadiumCapacity
@onready var stadium_year_label: Label = $TeamInfo/StadiumYearBuilt


func set_up(team: Team) -> void:
	player_list.set_up(team.id)
	_set_labels(team)


func set_team(team: Team) -> void:
	player_list.set_up(team.id)
	_set_labels(team)


func _set_labels(team: Team) -> void:
	name_label.text = team.name
	prestige_stars_label.text = tr("PRESTIGE") + " " + team.get_prestige_stars()
	prestige_label.text = str(team.get_prestige())
	budget_label.text = tr("BUDGET") + " " + FormatUtil.get_sign(team.budget)
	salary_budget_label.text = tr("SALARY_BUDGET") + " " + FormatUtil.get_sign(team.salary_budget)
	stadium_name_label.text = team.stadium.name
	stadium_capacity_label.text = str(team.stadium.capacity) + " " + tr("PERSONS")
	stadium_year_label.text = tr("YEAR") + " " + str(team.stadium.year_built)
