# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

# paths
const THEMES_PATH: StringName = "res://themes/"
const BASE_PATH: StringName = "res://theme_base/"
# theme
const THEME_FILE: StringName = BASE_PATH + "theme.tres"
# label
const LABEL_SETTINGS_FILE: StringName = BASE_PATH + "label/label_settings.tres"
const LABEL_SETTINGS_BOLD_FILE: StringName = BASE_PATH + "label/label_settings_bold.tres"
# style boxes flat
const BOX_NORMAL_FILE: StringName = BASE_PATH + "styles/box/box_normal.tres"
const BOX_PRESSED_FILE: StringName = BASE_PATH + "styles/box/box_pressed.tres"
const BOX_FOCUS_FILE: StringName = BASE_PATH + "styles/box/box_focus.tres"
const BOX_HOVER_FILE: StringName = BASE_PATH + "styles/box/box_hover.tres"
const BOX_DISABLED_FILE: StringName = BASE_PATH + "styles/box/box_disabled.tres"
const BOX_BACKGROUND_FILE: StringName = BASE_PATH + "styles/box/box_background.tres"
# style important boxes flat
const BOX_IMPORTANT_NORMAL_FILE: StringName = BASE_PATH + "styles/box_important/box_important_normal.tres"
const BOX_IMPORTANT_PRESSED_FILE: StringName = BASE_PATH + "styles/box_important/box_important_pressed.tres"
const BOX_IMPORTANT_FOCUS_FILE: StringName = BASE_PATH + "styles/box_important/box_important_focus.tres"
const BOX_IMPORTANT_HOVER_FILE: StringName = BASE_PATH + "styles/box_important/box_important_hover.tres"
const BOX_IMPORTANT_DISABLED_FILE: StringName = BASE_PATH + "styles/box_important/box_important_disabled.tres"
const BOX_IMPORTANT_BACKGROUND_FILE: StringName = BASE_PATH + "styles/box_important/box_important_background.tres"
# style boxes line
const LINE_H_NORMAL_FILE: StringName = BASE_PATH + "styles/lines/line_h_normal.tres"
const LINE_H_FOCUS_FILE: StringName = BASE_PATH + "styles/lines/line_h_focus.tres"
const LINE_H_THIN_FILE: StringName = BASE_PATH + "styles/lines/line_h_thin.tres"
const LINE_V_NORMAL_FILE: StringName = BASE_PATH + "styles/lines/line_v_normal.tres"
const LINE_V_FOCUS_FILE: StringName = BASE_PATH + "styles/lines/line_v_focus.tres"
const LINE_V_THIN_FILE: StringName = BASE_PATH + "styles/lines/line_v_thin.tres"


const THEMES: Dictionary = {
	"DARK": "theme_dark.tres", 
	"LIGHT": "theme_light.tres", 
	"SOLARIZED_LIGHT": "theme_solarized_light.tres", 
	"SOLARIZED_DARK": "theme_solarized_dark.tres", 
	"RED": "theme_red.tres",
	"HACKER": "theme_hacker.tres",
	"CUSTOM": "",
}

var theme: Theme

var label_settings_bold: LabelSettings
var label_settings: LabelSettings

var box_normal: StyleBoxFlat
var box_pressed: StyleBoxFlat
var box_focus: StyleBoxFlat
var box_hover: StyleBoxFlat
var box_disabled: StyleBoxFlat

var box_important_normal: StyleBoxFlat
var box_important_pressed: StyleBoxFlat
var box_important_focus: StyleBoxFlat
var box_important_hover: StyleBoxFlat
var box_important_disabled: StyleBoxFlat

var box_background: StyleBoxFlat

var line_h_normal: StyleBoxLine
var line_h_focus: StyleBoxLine
var line_h_thin: StyleBoxLine
var line_v_normal: StyleBoxLine
var line_v_focus: StyleBoxLine
var line_v_thin: StyleBoxLine

var custom_configuration: ThemeConfiguration


func _ready() -> void:
	# load resources
	theme = ResourceLoader.load(THEME_FILE, "Theme")
	# label
	label_settings = ResourceLoader.load(LABEL_SETTINGS_FILE, "LabelSettings")
	label_settings_bold = ResourceLoader.load(LABEL_SETTINGS_BOLD_FILE, "LabelSettings")
	# style boxes flat
	box_normal = ResourceLoader.load(BOX_NORMAL_FILE, "StyleBoxFlat")
	box_pressed = ResourceLoader.load(BOX_PRESSED_FILE, "StyleBoxFlat")
	box_focus = ResourceLoader.load(BOX_FOCUS_FILE, "StyleBoxFlat")
	box_hover = ResourceLoader.load(BOX_HOVER_FILE, "StyleBoxFlat")
	box_disabled = ResourceLoader.load(BOX_DISABLED_FILE, "StyleBoxFlat")
	# style important boxes flat
	box_important_normal = ResourceLoader.load(BOX_IMPORTANT_NORMAL_FILE, "StyleBoxFlat")
	box_important_pressed = ResourceLoader.load(BOX_IMPORTANT_PRESSED_FILE, "StyleBoxFlat")
	box_important_focus = ResourceLoader.load(BOX_IMPORTANT_FOCUS_FILE, "StyleBoxFlat")
	box_important_hover = ResourceLoader.load(BOX_IMPORTANT_HOVER_FILE, "StyleBoxFlat")
	box_important_disabled = ResourceLoader.load(BOX_IMPORTANT_DISABLED_FILE, "StyleBoxFlat")
	# background
	box_background = ResourceLoader.load(BOX_BACKGROUND_FILE, "StyleBoxFlat")
	# style boxes line
	line_h_normal = ResourceLoader.load(LINE_H_NORMAL_FILE, "StyleBoxLine")
	line_h_focus = ResourceLoader.load(LINE_H_FOCUS_FILE, "StyleBoxLine")
	line_h_thin = ResourceLoader.load(LINE_H_THIN_FILE, "StyleBoxLine")
	line_v_normal = ResourceLoader.load(LINE_V_NORMAL_FILE, "StyleBoxLine")
	line_v_focus = ResourceLoader.load(LINE_V_FOCUS_FILE, "StyleBoxLine")
	line_v_thin = ResourceLoader.load(LINE_V_THIN_FILE, "StyleBoxLine")

	custom_configuration = ThemeConfiguration.new()
	custom_configuration.font_color = Global.theme_custom_font_color
	custom_configuration.style_color = Global.theme_custom_style_color
	custom_configuration.background_color = Global.theme_custom_background_color

	apply_theme(THEMES.keys()[Global.theme_index])


func get_active_theme() -> Theme:
	return theme


func is_custom_theme() -> bool:
	return THEMES.keys()[Global.theme_index] == "CUSTOM"


func get_theme_names() -> Array:
	return THEMES.keys()


func reset_to_default() -> Theme:
	Global.theme_index = 0
	return apply_theme(THEMES.keys()[0])


func bold(label: Label, condition: bool = true) -> void:
	if condition:
		label.label_settings = label_settings_bold


func remove_bold(label: Label) -> void:
	label.label_settings = label_settings


func reload_active_theme() -> Theme:
	return apply_theme(THEMES.keys()[Global.theme_index])


func apply_theme(theme_name: StringName) -> Theme:
	if theme_name == "CUSTOM":
		custom_configuration.font_color = Global.theme_custom_font_color
		custom_configuration.style_color = Global.theme_custom_style_color
		custom_configuration.background_color = Global.theme_custom_background_color
		custom_configuration.setup()
		_apply_configuration(custom_configuration)
	else:
		var theme_file: StringName = THEMES[theme_name]
		var configuration: ThemeConfiguration = ResourceLoader.load(THEMES_PATH + theme_file)
		configuration.setup()
		_apply_configuration(configuration)

	return theme


func _apply_configuration(configuration: ThemeConfiguration) -> void:
	# box colors
	box_normal.bg_color = configuration.style_color_variation.normal
	box_focus.bg_color = configuration.style_color_variation.focus
	box_focus.border_color = configuration.style_color_variation.disabled
	box_pressed.bg_color = configuration.style_color_variation.pressed
	box_hover.bg_color = configuration.style_color_variation.hover
	box_disabled.bg_color = configuration.style_color_variation.disabled
	# box important colors
	box_important_normal.bg_color = configuration.style_important_color_variation.normal
	box_important_focus.bg_color = configuration.style_important_color_variation.focus
	box_important_focus.border_color = configuration.style_important_color_variation.disabled
	box_important_pressed.bg_color = configuration.style_important_color_variation.pressed
	box_important_hover.bg_color = configuration.style_important_color_variation.hover
	box_important_disabled.bg_color = configuration.style_important_color_variation.disabled
	# background
	box_background.bg_color = configuration.background_color
	# line colors
	line_h_normal.color = configuration.style_color_variation.normal
	line_h_focus.color = configuration.style_color_variation.focus
	line_v_normal.color = configuration.style_color_variation.normal
	line_v_focus.color = configuration.style_color_variation.focus
	# thin lines for splitters
	line_h_thin.color = configuration.font_color
	line_v_thin.color = configuration.font_color
	line_h_thin.color.a *= 0.5
	line_v_thin.color.a *= 0.5
	# label settings
	label_settings.font_color = configuration.font_color
	label_settings_bold.font_color = configuration.font_color
	label_settings_bold.outline_color = configuration.font_color

	# fontsize
	theme.default_font_size = Global.theme_font_size
	label_settings.font_size = Global.theme_font_size 
	label_settings_bold.font_size = Global.theme_font_size

	# labels
	theme.set_color("font_color", "Label", configuration.font_color)
	
	# rich text label
	theme.set_color("default_color", "RichTextLabel", configuration.font_color)
	
	# button  font colors
	theme.set_color("font_color", "Button", configuration.font_color)
	theme.set_color("font_focus_color", "Button", configuration.font_color_variation.focus)
	theme.set_color("font_hover_color", "Button", configuration.font_color_variation.hover)
	theme.set_color("font_pressed_color", "Button", configuration.font_color_variation.pressed)
	theme.set_color("font_disabled_color", "Button", configuration.font_color_variation.disabled)

	# link button
	theme.set_color("font_color", "LinkButton", configuration.font_color)
	theme.set_color("font_hover_color", "LinkButton", configuration.font_color_variation.hover)
	
	# progress bar
	theme.set_color("font_color", "ProgressBar", configuration.font_color)

	# line edit
	theme.set_color("font_color", "LineEdit", configuration.font_color_variation.hover)
	theme.set_color("font_selected_color", "LineEdit", configuration.font_color)
	theme.set_color("font_placeholder_color", "LineEdit", configuration.font_color_variation.hover)

	# popup menu
	theme.set_color("font_color", "PopupMenu", configuration.font_color)
	theme.set_color("font_hover_color", "PopupMenu", configuration.font_color_variation.hover)

	# tree
	theme.set_color("font_color", "Tree", configuration.font_color)
	theme.set_color("font_selected_color", "Tree", configuration.font_color_variation.focus)
	theme.set_color("font_outline_color", "Tree", configuration.font_color_variation.hover)
	theme.set_color("font_disabled_color", "Tree", configuration.font_color_variation.disabled)
	
	# tab container
	theme.set_color("font_selected_color", "TabContainer", configuration.font_color)
	theme.set_color("font_unselected_color", "TabContainer", configuration.font_color_variation.focus)
	theme.set_color("font_hovered_color", "TabContainer", configuration.font_color_variation.focus)
	theme.set_color("font_outline_color", "TabContainer", configuration.font_color_variation.hover)
	theme.set_color("font_disabled_color", "TabContainer", configuration.font_color_variation.disabled)


func get_default_scale() -> float:
	if OS.get_name() in ["Android", "iOS"]:
		return 1.5
	return 1