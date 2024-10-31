# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Settings
extends Control

enum ColorType {
	FONT,
	STYLE,
	BACKGROUND,
}

const RESOLUTIONS: Dictionary = {
	"3840x2160": Vector2i(3840, 2160),
	"2560x1440": Vector2i(2560, 1080),
	"1920x1080": Vector2i(1920, 1080),
	"1366x768": Vector2i(1366, 768),
	"1536x864": Vector2i(1536, 864),
	"1280x720": Vector2i(1280, 720),
	"1440x900": Vector2i(1440, 900),
	"1600x900": Vector2i(1600, 900),
	"1024x600": Vector2i(1024, 600),
	"800x600": Vector2i(800, 600)
}

var active_color_type: ColorType

@onready var theme_options: OptionButton = $VBoxContainer/Theme/ThemeOptionButton
@onready var resolution_options: OptionButton = $VBoxContainer/Resolution/ResolutionOptionButton

@onready var version_label: Label = $VBoxContainer/Version/VersionLabel

@onready var font_size_spinbox: SpinBox = $VBoxContainer/FontSize/FontSizeSpinBox
@onready var color_picker_popup: PopupPanel = $ColorPopupPanel
@onready var color_picker: ColorPicker = $ColorPopupPanel/MarginContainer/ColorPicker


func _ready() -> void:
	# theme
	theme = ThemeUtil.get_active_theme()
	InputUtil.start_focus(self)

	font_size_spinbox.value = Global.theme_font_size
	font_size_spinbox.min_value = Const.FONT_SIZE_MIN
	font_size_spinbox.max_value = Const.FONT_SIZE_MAX

	for theme_name: String in ThemeUtil.get_theme_names():
		theme_options.add_item(theme_name)
	theme_options.selected = Global.theme_index

	# resolutions
	for resolution: String in RESOLUTIONS.keys():
		resolution_options.add_item(resolution)
	resolution_options.selected = 0

	version_label.text = Global.version


func _on_theme_option_button_item_selected(index: int) -> void:
	var theme_name: String = theme_options.get_item_text(index)
	theme = ThemeUtil.apply_theme(theme_name)
	Global.theme_index = index
	Global.save_config()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_resolution_option_button_item_selected(index: int) -> void:
	size = RESOLUTIONS[RESOLUTIONS.keys()[index]]


func _on_defaults_pressed() -> void:
	# font size
	Global.theme_font_size = Const.FONT_SIZE_DEFAULT
	font_size_spinbox.value = Global.theme_font_size
	# theme
	theme = ThemeUtil.reset_to_default()
	theme_options.selected = 0
	# resolution
	size = RESOLUTIONS[RESOLUTIONS.keys()[2]]
	resolution_options.selected = 2
	Global.save_config()


func _on_font_default_button_pressed() -> void:
	Global.theme_font_size = Const.FONT_SIZE_DEFAULT
	font_size_spinbox.value = Global.theme_font_size
	ThemeUtil.reload_active_theme()
	Global.save_config()


func _on_font_size_spin_box_value_changed(value: float) -> void:
	Global.theme_font_size = int(value)
	ThemeUtil.reload_active_theme()
	Global.save_config()


func _on_font_color_button_pressed() -> void:
	active_color_type = ColorType.FONT
	color_picker.color = Global.theme_custom_font_color
	color_picker_popup.popup_centered()


func _on_style_color_button_pressed() -> void:
	active_color_type = ColorType.STYLE
	color_picker.color = Global.theme_custom_style_color
	color_picker_popup.popup_centered()


func _on_background_color_button_pressed() -> void:
	active_color_type = ColorType.BACKGROUND
	color_picker.color = Global.theme_custom_background_color
	color_picker_popup.popup_centered()


func _on_close_color_picker_button_pressed() -> void:
	color_picker_popup.hide()


func _on_color_picker_color_changed(color: Color) -> void:
	print(color)
	match active_color_type:
		ColorType.FONT:
			Global.theme_custom_font_color = color
		ColorType.STYLE:
			Global.theme_custom_style_color = color
		ColorType.BACKGROUND:
			Global.theme_custom_background_color = color
		_:
			print("color type not defined")

	if ThemeUtil.is_custom_theme():
		ThemeUtil.reload_active_theme()

