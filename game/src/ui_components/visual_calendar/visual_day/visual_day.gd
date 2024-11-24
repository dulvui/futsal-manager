# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualDay
extends MarginContainer

signal show_match_list

const HOME_MATCH_DAY_COLOR: Color = Color.DODGER_BLUE
const AWAY_MATCH_DAY_COLOR: Color = Color.FIREBRICK

var date: Day

@onready var button: Button = %Button
@onready var month_day_label: Label = %MonthDay
@onready var market_label: Label = %Market
@onready var competition: VBoxContainer = %Competition
@onready var competition_name: Label = %CompetitionName
@onready var team_name_label: Label = %TeamName
@onready var match_color: ColorRect = %MatchColor
@onready var day_color: ColorRect = $DayColor


func setup(p_date: Day = Day.new(), matchz: Match = null) -> void:
	date = p_date
	# activate button
	button.show()

	month_day_label.text = str(date.day)

	if matchz != null:
		if Global.team.name == matchz.home.name:
			competition_name.text = matchz.competition_name
			team_name_label.text = matchz.away.name
			match_color.color = HOME_MATCH_DAY_COLOR
			match_color.show()
			competition.show()
		elif Global.team.name == matchz.away.name:
			competition_name.text = matchz.competition_name
			team_name_label.text = matchz.home.name
			match_color.color = AWAY_MATCH_DAY_COLOR
			competition.show()
			match_color.show()
	else:
		competition.hide()
		match_color.hide()

	if date.is_same_day(Global.world.calendar.day()):
		if day_color.color != HOME_MATCH_DAY_COLOR:
			day_color.color = Color.LIGHT_GREEN
		elif day_color.color != AWAY_MATCH_DAY_COLOR:
			day_color.color = Color.MEDIUM_SPRING_GREEN
		else:
			day_color.color = Color.LIGHT_PINK

	# check if market is active
	if date.market:
		market_label.text = tr("TRANSFERMARKET")
	else:
		market_label.text = ""



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
