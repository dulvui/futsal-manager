# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualDay
extends Control

signal show_match_list

const HOME_MATCH_DAY_COLOR: Color = Color.DODGER_BLUE
const AWAY_MATCH_DAY_COLOR: Color = Color.DEEP_SKY_BLUE

var date: Day

@onready var button: Button = %Button
@onready var match_label: Label = %Match
@onready var month_day_label: Label = %MonthDay
@onready var market_label: Label = %Market
@onready var competition: HBoxContainer = %Competition
@onready var competition_name: Label = %CompetitionName
@onready var match_color: ColorRect = %MatchColor
@onready var day_color: ColorRect = $DayColor


func set_up(p_date: Day = Day.new()) -> void:
	date = p_date
	# activate button
	button.show()

	competition.visible = false

	month_day_label.text = str(date.day)
	var team_name: String
	var matches: Array = date.get_matches()
	if matches.size() > 0:
		for matchz: Match in matches:
			if Global.team.name == matchz.home.name:
				team_name = matchz.away.name
				match_color.show()
				match_color.color = HOME_MATCH_DAY_COLOR
				competition.visible = true
				competition_name.text = matchz.competition_name
			elif Global.team.name == matchz.away.name:
				team_name = matchz.home.name
				match_color.show()
				match_color.color = AWAY_MATCH_DAY_COLOR
				competition.visible = true
				competition_name.text = matchz.competition_name
		match_label.text = team_name
	else:
		match_label.hide()

	if date.is_same_day(Global.world.calendar.day()):
		if day_color.color != HOME_MATCH_DAY_COLOR:
			day_color.color = Color.LIGHT_GREEN
		elif day_color.color != AWAY_MATCH_DAY_COLOR:
			day_color.color = Color.MEDIUM_SPRING_GREEN
		else:
			day_color.color = Color.LIGHT_PINK

	# check if market is active
	if date.market:
		market_label.text = tr("MARKET")


func unselect() -> void:
	# color_active.color = Color(0, 0, 0, 0)
	ThemeUtil.remove_bold(month_day_label)


func select() -> void:
	# color_active.color = Color(0, 0, 0, 0.3)
	ThemeUtil.bold(month_day_label)


func _on_button_pressed() -> void:
	show_match_list.emit()
	# unselect other days
	get_tree().call_group("visual-day", "unselect")
	select()
