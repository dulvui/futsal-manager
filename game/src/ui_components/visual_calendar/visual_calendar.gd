# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualCalendar
extends HSplitContainer

const VisualDayScene: PackedScene = preload(
	"res://src/ui_components/visual_calendar/visual_day/visual_day.tscn"
)

var current_month: int
var current_year: int
var max_months: int

@onready var match_list: VisualMatchList = $MatchList
@onready var days: GridContainer = $Calendar/Days
@onready var page_label: Label = $Calendar/Paginator/Page


func _ready() -> void:
	max_months = Config.world.calendar.months.size()
	current_month = Config.world.calendar.date.month
	current_year = Config.world.calendar.date.year
	set_up()


func set_up() -> void:
	set_up_days()
	match_list.set_up(Config.world.calendar.day())


func set_up_days() -> void:
	# clean grid container
	for child in days.get_children():
		if not child is Label:
			child.queue_free()

	# to start with monday, fill other days with transparent days
	var monday_counter: int = 7
	while Config.world.calendar.month(current_month).days[monday_counter].weekday != "MON":
		var calendar_day: VisualDay = VisualDayScene.instantiate()
		days.add_child(calendar_day)
		calendar_day.modulate = Color(0, 0, 0, 0)
		monday_counter -= 1

	# add days
	for day: Day in Config.world.calendar.month(current_month).days:
		var calendar_day: VisualDay = VisualDayScene.instantiate()
		days.add_child(calendar_day)
		calendar_day.set_up(day)
		calendar_day.show_match_list.connect(_on_calendar_day_pressed.bind(day))

		# make current day active
		if day == Config.world.calendar.day():
			calendar_day.select()

	var active_year: int = current_year + ((current_month - 1) / 12)
	page_label.text = Const.MONTH_STRINGS[(current_month % 12) - 1] + " " + str(active_year)


func _on_calendar_day_pressed(day: Day) -> void:
	match_list.set_up(day)


func _on_prev_pressed() -> void:
	current_month -= 1
	if current_month < 1:
		current_month = 1
	set_up()


func _on_next_pressed() -> void:
	current_month += 1
	if current_month > max_months:
		current_month = max_months
	set_up()


func _on_today_pressed() -> void:
	current_month = Config.world.calendar.date.month
	set_up()
