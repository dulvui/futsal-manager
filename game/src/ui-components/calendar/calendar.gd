# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const Day:PackedScene = preload("res://src/ui-components/calendar/day/day.tscn")

@onready var grid:GridContainer = $Content/GridContainer

# get current month and show in paginator
# max back and forward is full current season
var current_month:int


func _ready() -> void:
	set_up(true)

func set_up(use_global_month:bool=false) -> void:
	if use_global_month:
		current_month = Config.date.month
	# clean grid container
	for child in grid.get_children():
		if not child is Label:
			child.queue_free()
	
	# start with monday: fill with transparent days
	var monday_counter:int = 7
	while Config.calendar[current_month][monday_counter]["weekday"] != "MON":
		var calendar_day: = Day.instantiate()
		calendar_day.modulate = Color(0,0,0,0)
		grid.add_child(calendar_day)
		monday_counter -= 1
		
	
	
	for day in range(0, Config.calendar[current_month].size()):
		var calendar_day:Control = Day.instantiate()
		grid.add_child(calendar_day)
		calendar_day.set_up(Config.calendar[current_month][day])
#
	$Content/Paginator/Page.text = CalendarUtil.MONTHS[current_month]
	

func _on_Prev_pressed() -> void:
	current_month -= 1
	if current_month < 0:
		current_month = 0
	set_up()
	
func _on_Next_pressed() -> void:
	current_month += 1
	if current_month > 11:
		current_month = 11
	set_up()
