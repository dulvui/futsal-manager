# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal select_player(player:Player)
signal info_player(player:Player)

const ColorNumber = preload("res://src/ui-components/color-number/color_number.tscn")
const NameLabel = preload("res://src/ui-components/player-list/table/name-label/name_label.tscn")

@onready var header_container = $VBoxContainer/Header
@onready var content_container = $VBoxContainer/ScrollContainer/Content

var headers:Array[String]
var players:Array[Player] # base content
var info_type:String

# TODO use content container direcltly to save memory
var color_numbers:Array[ColorNumber]

var sort_memory:Dictionary = {} # to save wich value is already sorted and how

	
func set_up(_headers:Array[String], _info_type:String, _players:Array[Player]=[]) -> void:
	headers = _headers
	info_type = _info_type
	players = _players
	
	for key in Constants.ATTRIBUTES.keys():
		for attribute in Constants.ATTRIBUTES[key]:
			sort_memory[key + "_" + attribute] = false
	
	_set_up_headers()
	_set_up_content()

func update(_headers:Array[String], _info_type:String) -> void:
	info_type = _info_type
	headers = _headers
	# todo replace with update
	_set_up_headers()
	_update_content()

func _set_up_headers() -> void:
	for header in header_container.get_children():
		header.queue_free()
	
	# name header
	var name_button:Button = Button.new()
	name_button.text = headers[0]
	name_button.custom_minimum_size.x = 252
	name_button.button_down.connect(_sort.bind(headers[0]))
	header_container.add_child(name_button)
	
	# ohter headers
	for header in headers.slice(1):
		var button:Button = Button.new()
		button.custom_minimum_size.x = 34
		button.text = header.substr(0,3)
		button.button_down.connect(_sort.bind(header))
		header_container.add_child(button)
	
	# info label
	var label:Label = Label.new()
	label.text = "info"
	label.custom_minimum_size.x = 72
	header_container.add_child(label)
	
	# change label
	var label_change:Label = Label.new()
	label_change.text = "choose"
	label_change.custom_minimum_size.x = 72
	header_container.add_child(label_change)
	
func _set_up_content() -> void:
	
	content_container.columns = headers.size() + 2 # +2 for info and change button
	
	if players.size() > 0:
		for player in players:
			
			var name_label = NameLabel.instantiate()
			name_label.set_text(player.surname)
			content_container.add_child(name_label)
			for key in Constants.ATTRIBUTES.keys():
				for attribute in Constants.ATTRIBUTES[key]:
					var label = ColorNumber.instantiate()
					label.key = attribute
					label.set_up(player.attributes.get(key).get(attribute))
					content_container.add_child(label)
					label.visible = attribute in headers
					color_numbers.append(label)

			#info button
			var button = Button.new()
			button.text = "info"
			button.button_down.connect(show_info.bind(player))
			content_container.add_child(button)

			#change button
			var button_change = Button.new()
			button_change.text = "choose"
			button_change.button_down.connect(change_player.bind(player))
			content_container.add_child(button_change)
	else :
		var label = Label.new()
		label.text = "NO_PLAYER_FOUND"
		content_container.add_child(label)
		
func _update_content() -> void:
	content_container.columns = headers.size() + 2
	for color_number in color_numbers:
		color_number.visible = color_number.key in headers

func filter(filters: Dictionary, exlusive = false) -> void:
	if filters:
		var filtered_content = []
		for player in players:
			var filter_counter = 0
			# because value can be empty
			var valid_filter_counter = 0
			for key in filters.keys():
				var value = filters[key]
				if value:
					pass
					# TODO create player labels with player info, that can be hidden or shown
#					if exlusive:
#						player.visible = not str(value).to_upper() in str(player[key]).to_upper():
#					else:
#						player.visible = str(value).to_upper() in str(player[key]).to_upper():
						
	

func show_info(player:Player) -> void:
	info_player.emit(player)
	
func change_player(player:Player) -> void:
	select_player.emit(player)
	
func _sort(key:String, value:String) -> void:
	players.sort_custom(func(a, b): return a[key][value] < b[key][value])
	
	sort_memory[key][value] = not sort_memory[key][value]
	
	if sort_memory[key][value]:
		players.reverse()
	
	_set_up_content()
