# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MatchSimulator
extends Control

signal action_message(message: String)
signal half_time
signal match_end
signal update_time

const CAMERA_SPEED: int = 4

var ticks: int = 0
var time: int = 0
var timer: Timer

var match_engine: MatchEngine

@onready var visual_match: VisualMatch = $SubViewportContainer/SubViewport/VisualMatch
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var camera: Camera2D = $SubViewportContainer/SubViewport/Camera2D


func _physics_process(delta: float) -> void:
	camera.position = camera.position.lerp(visual_match.visual_ball.global_position, delta * CAMERA_SPEED)


func setup(home_team: Team, away_team: Team, match_seed: int) -> void:
	# intialize timer
	timer = Timer.new()
	timer.wait_time = 1.0 / (Const.TICKS_PER_SECOND * Global.speed_factor)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	match_engine = MatchEngine.new()
	match_engine.setup(home_team, away_team, match_seed)

	# connect change players signals to visuals
	match_engine.home_team.player_changed.connect(
		func() -> void:
			visual_match.home_team.change_players(match_engine.home_team)
	)
	match_engine.away_team.player_changed.connect(
		func() -> void:
			visual_match.away_team.change_players(match_engine.away_team)
	)

	# set up visual match
	# get colors
	visual_match.setup(match_engine, timer.wait_time)

	# adjust sub viewport to field size + borders
	sub_viewport.size = visual_match.visual_field.field.size

	# set camera limits
	var camera_offset: int = 100
	camera.limit_left = -camera_offset
	camera.limit_top = -camera_offset
	camera.limit_right = match_engine.field.size.x + camera_offset
	camera.limit_bottom = match_engine.field.size.y + camera_offset

	# reset match_paused
	Global.match_paused = false


func simulate(end_time: int = Const.FULL_TIME_SECONDS) -> void:
	# save simulated flags, to restore if endtime < FULL_TIME_SECONDS
	var home_simulated: bool = match_engine.home_team.simulated
	var away_simulated: bool = match_engine.away_team.simulated
	# set simulation flags to activate auto changes ecc
	match_engine.home_team.simulated = true
	match_engine.away_team.simulated = true

	timer.stop()
	
	# first half
	if time < Const.HALF_TIME_SECONDS:
		while time < Const.HALF_TIME_SECONDS:
			match_engine.update()
			_tick()
			# stop simulation
			if time == end_time:
				match_engine.home_team.simulated = home_simulated
				match_engine.away_team.simulated = away_simulated
				timer.start()
				return

		match_engine.half_time()
	
	# second half
	while time < Const.FULL_TIME_SECONDS:
		match_engine.update()
		_tick()
		# stop simulation
		if time == end_time:
			match_engine.home_team.simulated = home_simulated
			match_engine.away_team.simulated = away_simulated
			timer.start()
			return
	
	match_engine.full_time()


func pause_toggle() -> bool:
	timer.paused = not timer.paused
	Global.match_paused = timer.paused
	return timer.paused


func pause() -> void:
	timer.paused = true
	Global.match_paused = timer.paused


func continue_match() -> void:
	timer.paused = false


func match_finished() -> void:
	action_message.emit("match finished")
	timer.stop()


func set_time() -> void:
	timer.wait_time = 1.0 / (Const.TICKS_PER_SECOND * Global.speed_factor)


func start_match() -> void:
	action_message.emit("match started")
	timer.start()


func _on_timer_timeout() -> void:
	match_engine.update()
	visual_match.update(timer.wait_time)
	_tick()


func _tick() -> void:
	ticks += 1
	# only update tiem on clock, after TICKS_PER_SECOND passed
	if ticks == Const.TICKS_PER_SECOND:
		ticks = 0
		time += 1
		update_time.emit()
		# check half/end time
		if time == Const.HALF_TIME_SECONDS:
			timer.paused = true
			half_time.emit()
		elif time == Const.HALF_TIME_SECONDS * 2:
			timer.stop()
			match_end.emit()

