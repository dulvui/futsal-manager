# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Settings
extends Control

enum Screen {
	MENU,
	DASHBOARD,
	MATCH,
}

enum ColorType {
	FONT,
	STYLE,
	BACKGROUND,
}

var active_color_type: ColorType

@onready var theme_options: OptionButton = %ThemeOptionButton
@onready var ui_sfx_volume: HSlider = %UISfxVolumeSlider
@onready var version_label: Label = %VersionLabel
@onready var font_size_spinbox: SpinBox = %FontSizeSpinBox
@onready var color_picker_popup: PopupPanel = $ColorPopupPanel
@onready var color_picker: ColorPicker = $ColorPopupPanel/MarginContainer/ColorPicker
@onready var search_line_edit: LineEdit = %SearchLineEdit
@onready var default_dialog: ConfirmationDialog = %DefaultDialog


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

	version_label.text = "v" + Global.version
	
	ui_sfx_volume.value = SoundUtil.get_bus_volume(SoundUtil.AudioBus.UI_SFX)

	InputUtil.search.connect(func() -> void: search_line_edit.grab_focus())


func _on_theme_option_button_item_selected(index: int) -> void:
	var theme_name: String = theme_options.get_item_text(index)
	theme = ThemeUtil.apply_theme(theme_name)
	Global.theme_index = index
	Global.save_config()


func _on_back_pressed() -> void:
	match Global.settings_screen:
		Screen.MENU:
			get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")
		Screen.DASHBOARD:
			get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
		_:
			get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")



func _on_defaults_pressed() -> void:
	default_dialog.popup_centered()


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


func _on_scale_1_pressed() -> void:
	get_tree().root.content_scale_factor = Const.SCALE_1
	Global.theme_scale = Const.SCALE_1
	Global.save_config()


func _on_scale_2_pressed() -> void:
	get_tree().root.content_scale_factor = Const.SCALE_2
	Global.theme_scale = Const.SCALE_2
	Global.save_config()


func _on_scale_3_pressed() -> void:
	get_tree().root.content_scale_factor = Const.SCALE_3
	Global.theme_scale = Const.SCALE_3
	Global.save_config()


func _on_ui_sfx_volume_slider_value_changed(value: float) -> void:
	SoundUtil.set_bus_volume(SoundUtil.AudioBus.UI_SFX, value)
	SoundUtil.set_bus_mute(SoundUtil.AudioBus.UI_SFX, value == ui_sfx_volume.min_value)
	SoundUtil.play_button_sfx()


func _on_default_dialog_confirmed() -> void:
	# font size
	Global.theme_font_size = Const.FONT_SIZE_DEFAULT
	font_size_spinbox.value = Global.theme_font_size
	# theme
	theme = ThemeUtil.reset_to_default()
	theme_options.selected = 0
	#scale
	get_tree().root.content_scale_factor = ThemeUtil.get_default_scale()
	Global.theme_scale = ThemeUtil.get_default_scale()
	# audio
	SoundUtil.restore_default()
	ui_sfx_volume.value = SoundUtil.get_bus_volume(SoundUtil.AudioBus.UI_SFX)
	
	Global.save_config()
