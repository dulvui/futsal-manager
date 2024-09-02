# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualDay
extends Control

signal show_match_list

const HOME_MATCH_DAY_COLOR: Color = Color.DODGER_BLUE
const AWAY_MATCH_DAY_COLOR: Color = Color.DEEP_SKY_BLUE

@onready var background: ColorRect = $Background
@onready var color_active: ColorRect = $ColorActive

@onready var button: Button = $Button

@onready var match_label: Label = $MarginContainer/VBoxContainer/Match
@onready var month_day_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/MonthDay
@onready var market_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Market

@onready var ball_texture: TextureRect = $MarginContainer/VBoxContainer/Ball

var date: Day


func set_up(p_date: Day = Day.new()) -> void:
	date = p_date
	# activate button
	button.show()
	
	ball_texture.visible = false

	month_day_label.text = str(date.day)
	var team_name: String
	if date.get_matches().size() > 0:
		for matchz: Match in date.get_matches():
			if Config.team.name == matchz.home.name:
				team_name = matchz.away.name
				background.color = HOME_MATCH_DAY_COLOR
				ball_texture.visible = true
			elif Config.team.name == matchz.away.name:
				team_name = matchz.home.name
				background.color = AWAY_MATCH_DAY_COLOR
				ball_texture.visible = true
		match_label.text = team_name
	else:
		match_label.hide()

	if date.day == Config.world.calendar.day().day and Config.world.calendar.day().month == date.month:
		if background.color != HOME_MATCH_DAY_COLOR:
			background.color = Color.LIGHT_GREEN
		elif background.color != AWAY_MATCH_DAY_COLOR:
			background.color = Color.MEDIUM_SPRING_GREEN
		else:
			background.color = Color.LIGHT_PINK

	# check if market is active
	if date.market:
		market_label.text = tr("MARKET")


func unselect() -> void:
	color_active.color = Color(0, 0, 0, 0)
	UiUtil.remove_bold(month_day_label)


func select() -> void:
	color_active.color = Color(0, 0, 0, 0.3)
	UiUtil.bold(month_day_label)


func _on_button_pressed() -> void:
	show_match_list.emit()
	# unselect other days
	get_tree().call_group("visual-day", "unselect")
	select()
