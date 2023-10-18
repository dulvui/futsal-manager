# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal select_player
signal info_player

const ColorNumber = preload("res://src/ui-components/color-number/color_number.tscn")
const NameLabel = preload("res://src/ui-components/player-list/table/name-label/name_label.tscn")

const SIZE:int = 10

@onready var content_container = $VBoxContainer/Content

@onready var pages = $VBoxContainer/HBoxContainer/Pages

var current_page:int = 0
var max_page:int = 0

var headers:Array[String]
var content:Array[Player] # base content
var current_content:Array[Player] # current visible content, can be filtered
var info_type:String

var sort_memory:Dictionary = {} # to save wich value is already sorted and how

	
func set_up(_headers:Array[String], _info_type:String, _content:Array[Player]=[]) -> void:
	headers = _headers
	info_type = _info_type
	
	# if content, table is setup for first time
	# else headers are changed
	if not _content.is_empty():
		content = _content
		current_content = content
	# set up sort memory
	for header in headers:
		sort_memory[header] = false
		
	_set_up_content()
	


func _set_up_headers() -> void:
	for header in headers:
		var button = Button.new()
		button.text = header.substr(0,3)
		button.button_down.connect(_sort.bind(header))
		content_container.add_child(button)
	
	# info label
	var label = Label.new()
	label.text = "i"
	content_container.add_child(label)
	
	# change label
	var lable_change = Label.new()
	lable_change.text = "c"
	content_container.add_child(lable_change)
	
func _set_up_content() -> void:
	for child in content_container.get_children():
		content_container.remove_child(child)
	
	_update_max_page()
	_set_up_headers()
	
	content_container.columns = headers.size() + 2 # +2 for info and change button
	if current_content.size() > 0:
		for item in current_content.slice(current_page * SIZE , (current_page * SIZE) + SIZE):
			for header in headers:
				var label
				if typeof(item.attributes.get(info_type).get(header)) == 2:
					label = ColorNumber.instantiate()
					label.set_up(item.attributes.get(info_type).get(header))
				else:
					label = NameLabel.instantiate()
					label.set_text(item.attributes.get(info_type).get(header))
				content_container.add_child(label)

			#info button
			var button = Button.new()
			button.text = "info"
			button.button_down.connect(show_info.bind(item))
			content_container.add_child(button)

			#change button
			var button_change = Button.new()
			button_change.text = "chose"
			button_change.button_down.connect(change_player.bind(item))
			content_container.add_child(button_change)
	else :
		var label = Label.new()
		label.text = "NO_PLAYER_FOUND"
		content_container.add_child(label)
		
	_update_pages()


func filter(filters: Dictionary, exlusive = false) -> void:
	if filters:
		current_page = 0
		var filtered_content = []
		for item in content:
			var filter_counter = 0
			# because value can be empty
			var valid_filter_counter = 0
			for key in filters.keys():
				var value = filters[key]
				if value:
					valid_filter_counter += 1
					if exlusive:
						if not str(value).to_upper() in str(item[key]).to_upper():
							filter_counter += 1
					else:
						if str(value).to_upper() in str(item[key]).to_upper():
							filter_counter += 1
			if filter_counter == valid_filter_counter:
				filtered_content.append(item)
		current_content = filtered_content
	else:
		current_content = content
	_set_up_content()
	

func show_info(player) -> void:
	emit_signal("info_player", player)
	
func change_player(player) -> void:
	emit_signal("select_player",player)
	
func _sort(value) -> void:
	current_content.sort_custom(func(a, b): return a[value] < b[value])
	
	sort_memory[value] = not sort_memory[value]
	
	if sort_memory[value]:
		current_content.reverse()
	
	_set_up_content()



func _on_Next_pressed() -> void:
	if current_page < max_page - 1:
		current_page += 1
		_set_up_content()
		_update_pages()
		

func _on_next_5_pressed():
	if current_page < max_page - 5:
		current_page += 5
	else:
		current_page = max_page - 1
	_set_up_content()
	_update_pages()


func _on_last_pressed():
	current_page = max_page - 1
	_set_up_content()
	_update_pages()
	

func _on_first_pressed():
	current_page = 0
	_set_up_content()
	_update_pages()
	


func _on_prev_5_pressed():
	if current_page > 4:
		current_page -= 5
	else:
		current_page = 0
	_set_up_content()
	_update_pages()


func _on_Prev_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		_set_up_content()
		_update_pages()
	
func _update_max_page() -> void:
	max_page = current_content.size()/SIZE
	if current_content.size() % SIZE != 0:
		max_page += 1

func _update_pages() -> void:
	pages.text = str(current_page + 1) + "/" + str(max_page)
	
