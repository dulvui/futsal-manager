# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name VisualDay

signal show_match_list

@onready var color_rect:ColorRect = $ColorRect
@onready var button:Button = $MarginContainer/Button

@onready var match_label:Label = $MarginContainer/VBoxContainer/Match
@onready var month_day_label:Label = $MarginContainer/VBoxContainer/HBoxContainer/MonthDay
@onready var market_label:Label = $MarginContainer/VBoxContainer/HBoxContainer/Market

var date:Day

func set_up(p_date:Day = Day.new()) -> void:
	date = p_date
	month_day_label.text = str(date.day)
	var team_name:String
	if date.matches.size() > 0:
		for matchz:Match in date.matches:
			if Config.team.name == matchz.home.name:
				team_name = matchz.away.name
				color_rect.color = Color.DODGER_BLUE
			elif Config.team.name ==  matchz.away.name:
				team_name = matchz.home.name
				color_rect.color = Color.DEEP_SKY_BLUE
		match_label.text = team_name
	else:
		match_label.hide()
		
	if date.day == Config.calendar().day().day and Config.calendar().day().month == date.month:
		if color_rect.color != Color.DODGER_BLUE:
			color_rect.color = Color.LIGHT_GREEN
		elif color_rect.color != Color.DEEP_SKY_BLUE:
			color_rect.color = Color.MEDIUM_SPRING_GREEN
		else:
			color_rect.color = Color.LIGHT_PINK
			
	# check if market is active
	if date.market:
		market_label.text = "Market"

func _on_button_pressed() -> void:
	show_match_list.emit()
