# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var icon: TextureRect = %Icon

@onready var match_teaser: VBoxContainer = %MatchTeaser
@onready var match_screen: Control = %Match

@onready var dashboard_teaser: VBoxContainer = %DashboardTeaser
@onready var dashboard_screen: Dashboard = %Dashboard

@onready var coming_soon_teaser: VBoxContainer = %ComingSoon

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	# set initial modulates
	icon.modulate = Color.WHITE
	match_teaser.modulate = Color.TRANSPARENT
	match_screen.modulate = Color.TRANSPARENT
	dashboard_teaser.modulate = Color.TRANSPARENT
	dashboard_screen.modulate = Color.TRANSPARENT

# func _process(delta: float) -> void:
	print("START MOVIE")
	
	# icon
	await wait(2)
	await fade_out(icon)

	# match teaser
	await fade_in(match_teaser)
	await wait(3)
	await fade_out(match_teaser)
	
	# match
	await fade_in(match_screen)
	await wait(6)
	await fade_out(match_screen)
	
	# dashboard teaser
	await fade_in(dashboard_teaser)
	await wait(3)
	await fade_out(dashboard_teaser)
	
	# dashboard
	await fade_in(dashboard_screen)
	await wait(2)
	dashboard_screen._on_formation_button_pressed()
	await wait(2)
	dashboard_screen._on_search_player_button_pressed()
	await wait(2)
	await fade_out(dashboard_screen)

	# coming soon teaser
	await fade_in(coming_soon_teaser)
	await wait(5)

	# quit scene to finish registration
	print("END MOVIE")
	get_tree().quit()


func wait(time: float) -> void:
	print("wait for %f seconds"%time)
	var timer: Timer = Timer.new()
	timer.wait_time = time
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	print("wait done")


func fade_in(node: Node) -> void:
	print("fading in...")
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate", Color.WHITE, 0.5)
	await tween.finished 
	print("fading in done.")


func fade_out(node: Node) -> void:
	print("fading out...")
	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate", Color.TRANSPARENT, 0.5)
	await tween.finished 
	print("fading out done.")

