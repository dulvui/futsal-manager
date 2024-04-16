# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name TeamProfile

@onready var player_list:PlayerList = $VBoxContainer/HBoxContainer/PlayerList
@onready var name_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/Name
@onready var prestige_stars_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/PresitgeStars
@onready var prestige_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/Presitge
@onready var budget_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/Budget
@onready var salary_budget_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/SalaryBudget
@onready var stadium_name_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/StadiumName
@onready var stadium_capacity_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/StadiumCapacity
@onready var stadium_year_label:Label = $VBoxContainer/HBoxContainer/TeamInfo/StadiumYearBuilt

func set_up(team:Team) -> void:
	player_list.set_up(false, true, team, false)
	_set_labels(team)

func set_team(team:Team) -> void:
	player_list.set_up_players(false, team, true)
	_set_labels(team)

func _set_labels(team:Team) -> void:
	name_label.text = team.name
	prestige_stars_label.text = tr("PRESTIGE") + " " + team.get_prestige_stars()
	prestige_label.text = str(team.get_prestige())
	budget_label.text = tr("BUDGET") + " " + CurrencyUtil.get_sign(team.budget)
	salary_budget_label.text =tr("SALARY_BUDGET") + " " + CurrencyUtil.get_sign(team.salary_budget)
	stadium_name_label.text = team.stadium.name
	stadium_capacity_label.text = str(team.stadium.capacity) + " " + tr("PERSONS")
	stadium_year_label.text = tr("YEAR") + " " + str(team.stadium.year_built)
	

