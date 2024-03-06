# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const VisualDay:PackedScene = preload("res://src/ui-components/visual-calendar/visual-day/visual-day.tscn")

@onready var grid:GridContainer = $Content/GridContainer
@onready var page_label:Label = $Content/Paginator/Page

# get current month and show in paginator
# max back and forward is full current season
var current_month:int


func _ready() -> void:
	set_up()

func set_up() -> void:
	# clean grid container
	for child in grid.get_children():
		if not child is Label:
			child.queue_free()
	
	# to start with monday, fill other days with transparent days
	var monday_counter:int = 7
	while Config.calendar().month().days[monday_counter].weekday != "MON":
		var calendar_day: = VisualDay.instantiate()
		calendar_day.modulate = Color(0,0,0,0)
		grid.add_child(calendar_day)
		monday_counter -= 1
	
	# add days
	for day:int in range(0, Config.calendar().month().days.size()):
		var calendar_day:Control = VisualDay.instantiate()
		grid.add_child(calendar_day)
		calendar_day.set_up(Config.calendar().month().days)

	page_label.text = Config.calendar().month_strings[current_month]
	

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
