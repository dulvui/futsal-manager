# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const visual_day:PackedScene = preload("res://src/ui-components/visual-calendar/visual-day/visual_day.tscn")

@onready var match_list:Control = $HSplitContainer/MatchList
@onready var days:GridContainer = $HSplitContainer/Calendar/Days
@onready var page_label:Label = $HSplitContainer/Calendar/Paginator/Page

# get current month and show in paginator
# max back and forward is full current season
var current_month:int

func _ready() -> void:
	current_month = Config.calendar().date.month - 1
	set_up()
	
func set_up() -> void:
	set_up_days()
	match_list.set_up(Config.calendar().day())

func set_up_days() -> void:
	# clean grid container
	for child in days.get_children():
		if not child is Label:
			child.queue_free()
	
	# to start with monday, fill other days with transparent days
	var monday_counter:int = 7
	while Config.calendar().month(current_month).days[monday_counter].weekday != "MON":
		var calendar_day:VisualDay = visual_day.instantiate()
		days.add_child(calendar_day)
		calendar_day.modulate = Color(0,0,0,0)
		monday_counter -= 1
	
	# add days
	for day:Day in Config.calendar().month(current_month).days:
		var calendar_day:VisualDay = visual_day.instantiate()
		days.add_child(calendar_day)
		calendar_day.set_up(day)
		calendar_day.show_match_list.connect(_on_calendar_day_pressed.bind(day))
		
		# make current day active
		if day == Config.calendar().day():
			calendar_day.select()

	page_label.text = Constants.month_strings[current_month]
	
func _on_calendar_day_pressed(day:Day) -> void:
	match_list.set_up(day)

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
