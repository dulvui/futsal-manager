# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Mapping

const BUTTON_MAPPING: Dictionary = {
	JoypadUtil.Type.PLAYSTATION: {
		JOY_BUTTON_A: "\u21E3", # cross
		JOY_BUTTON_B: "\u21E2", # circle
		JOY_BUTTON_X: "\u21E0", # square
		JOY_BUTTON_Y: "\u21E1", # triangle
		JOY_BUTTON_LEFT_SHOULDER: "\u21B0", # l1
		JOY_BUTTON_RIGHT_SHOULDER: "\u21B1", # r1
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
	JoypadUtil.Type.XBOX: {
		JOY_BUTTON_A: "\u21D3", # a 
		JOY_BUTTON_B: "\u21D2", # b
		JOY_BUTTON_X: "\u21D0", # x
		JOY_BUTTON_Y: "\u21D1", # y
		JOY_BUTTON_LEFT_SHOULDER: "\u2198", # lb
		JOY_BUTTON_RIGHT_SHOULDER: "\u2199", # rb
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
	JoypadUtil.Type.NINTENDO: {
		JOY_BUTTON_A: "\u21D2", # b
		JOY_BUTTON_B: "\u21D3", # a
		JOY_BUTTON_X: "\u21D1", # y
		JOY_BUTTON_Y: "\u21D0", # x
		JOY_BUTTON_LEFT_SHOULDER: "\u219C", # l
		JOY_BUTTON_RIGHT_SHOULDER: "\u219D", # r
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
	JoypadUtil.Type.GENERIC: {
		JOY_BUTTON_A: "\u24F5", # 1
		JOY_BUTTON_B: "\u24F6", # 2
		JOY_BUTTON_X: "\u24F7", # 3
		JOY_BUTTON_Y: "\u24F8", # 4
		JOY_BUTTON_LEFT_SHOULDER: "\u24F9", # 5 
		JOY_BUTTON_RIGHT_SHOULDER: "\u24FA", # 6
		JOY_BUTTON_START: "START", # start
		JOY_BUTTON_BACK: "SELECT", # select
	},
}

const AXIS_MAPPING: Dictionary = {
	JoypadUtil.Type.PLAYSTATION: {
		JOY_AXIS_TRIGGER_LEFT: "\u21B2", # r2
		JOY_AXIS_TRIGGER_RIGHT: "\u21B3", # l2
	},
	JoypadUtil.Type.XBOX: {
		JOY_AXIS_TRIGGER_LEFT: "\u2196", # lt
		JOY_AXIS_TRIGGER_RIGHT: "\u2197", # rt
	},
	JoypadUtil.Type.NINTENDO: {
		JOY_AXIS_TRIGGER_LEFT: "\u219A", # zl
		JOY_AXIS_TRIGGER_RIGHT: "\u219B", # zr
	},
	JoypadUtil.Type.GENERIC: {
		JOY_AXIS_TRIGGER_LEFT: "\u24F6B", # 7
		JOY_AXIS_TRIGGER_RIGHT: "\u24FC", # 8
	},
}
