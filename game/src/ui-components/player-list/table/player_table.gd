# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal select_player(player:Player)
signal info_player(player:Player)

const PlayerRow = preload("res://src/ui-components/player-list/player-row/player_row.tscn")

@onready var header_container = $VBoxContainer/Header
@onready var players_container = $VBoxContainer/Players
@onready var page_indicator = $VBoxContainer/Footer/PageIndicator

var headers:Array[String]
var players:Array[Player]

var info_type:String

var sort_memory:Dictionary = {} # to save wich value is already sorted and how

var page_size:int = 10
var page:int = 0
var page_max:int

	
func set_up(_headers:Array[String], _info_type:String, _players:Array[Player]=[]) -> void:
	headers = _headers
	info_type = _info_type
	players = _players
	
	page_max = players.size() / page_size
	
	_update_page_indicator()
	
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
	_set_up_content()
	_update_page_indicator()

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
	for child in players_container.get_children():
		child.queue_free()
	
	if players.size() > 0:
		for player in players.slice(page * page_size, (page + 1) * page_size):
			var player_row = PlayerRow.instantiate()
			players_container.add_child(player_row)
			player_row.select.connect(select.bind(player))
			player_row.info.connect(info.bind(player))
			player_row.set_up(player, headers)
	else :
		var label = Label.new()
		label.text = "NO_PLAYER_FOUND"
		players_container.add_child(label)
		

func _update_page_indicator() -> void:
	page_indicator.text = "%d / %d"%[page + 1, page_max + 1]

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
						
	

func info(player:Player) -> void:
	info_player.emit(player)
	
func select(player:Player) -> void:
	select_player.emit(player)
	
func _sort(key:String, value:String) -> void:
	players.sort_custom(func(a, b): return a[key][value] < b[key][value])
	
	sort_memory[key][value] = not sort_memory[key][value]
	
	if sort_memory[key][value]:
		players.reverse()
	
	_set_up_content()


func _on_next_2_pressed():
	page += 5
	if page > page_max:
		page = 0
	_update_page_indicator()
	_set_up_content()


func _on_next_pressed():
	page += 1
	if page > page_max:
		page = 0
	_update_page_indicator()
	_set_up_content()


func _on_prev_pressed():
	page -= 1
	if page < 0:
		page = page_max
	_update_page_indicator()
	_set_up_content()

func _on_prev_2_pressed():
	page -= 5
	if page < 0:
		page = page_max
	_update_page_indicator()
	_set_up_content()
