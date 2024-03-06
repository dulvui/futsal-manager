# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal click

const MatchList:PackedScene = preload("res://src/ui-components/visual-calendar/match-list/match_list.tscn")

@onready var color_rect:ColorRect = $ColorRect

@onready var match_button:Button = $MarginContainer/VBoxContainer/Match

@onready var month_day_label:Label = $MarginContainer/VBoxContainer/HBoxContainer/MonthDay

@onready var market_label:Label = $MarginContainer/VBoxContainer/HBoxContainer/Market

func set_up(date:Day) -> void:
#	print(date)
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
		match_button.pressed.connect(_on_Match_pressed.bind(date.matches))
		match_button.text = team_name
	else:
		match_button.hide()
		
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


func _on_Match_pressed(matches:Array[Match]) -> void:
	var match_list:Popup = MatchList.instantiate()
	add_child(match_list)
	match_list.show_matches(matches)

func _on_Close_pressed() -> void:
	$MatchPopup.hide()
