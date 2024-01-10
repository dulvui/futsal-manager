# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal info_player(player:Player)

const PlayerRow = preload("res://src/ui-components/player-list/player-row/player_row.tscn")

@onready var header_container:HBoxContainer = $VBoxContainer/Header
@onready var players_container:VBoxContainer = $VBoxContainer/Players
@onready var page_indicator:Label = $VBoxContainer/Footer/PageIndicator

var headers:Array[String]
var all_players:Array[Player]
var players:Array[Player]


var info_type:String

var sort_memory:Dictionary = {} # to save wich value is already sorted and how

const page_size:int = 9
var page:int = 0
var page_max:int
var team:Team

	
func set_up(
	p_headers:Array[String],
	p_info_type:String,
	p_players:Array[Player],
	p_team:Team = null
) -> void:
	headers = p_headers
	info_type = p_info_type
	players = p_players
	all_players = p_players
	team = p_team
	
	page_max = players.size() / page_size
	
	_update_page_indicator()
	
	sort_memory["surname"] = false
	sort_memory["position"] = false
	for key:String in Constants.ATTRIBUTES.keys():
		for attribute:String in Constants.ATTRIBUTES[key]:
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
	
	# position header
	var pos_button:Button = Button.new()
	pos_button.text = headers[0].substr(0,3)
	pos_button.custom_minimum_size.x = 34
	pos_button.button_down.connect(_sort_info.bind(headers[0]))
	header_container.add_child(pos_button)
	
	# name header
	var name_button:Button = Button.new()
	name_button.text = headers[1]
	name_button.custom_minimum_size.x = 252
	name_button.button_down.connect(_sort_info.bind(headers[1]))
	header_container.add_child(name_button)
	
	# ohter headers
	for header:String in headers.slice(2):
		var button:Button = Button.new()
		button.text = tr(header)
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_CHAR
		button.tooltip_text = tr(header)
		button.button_down.connect(_sort_attributes.bind(header))
		header_container.add_child(button)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
func _set_up_content() -> void:
	for child in players_container.get_children():
		child.queue_free()
	
	if players.size() > 0:
		for player:Player in players.slice(page * page_size, (page + 1) * page_size):
			var player_row:PlayerRow = PlayerRow.instantiate()
			players_container.add_child(player_row)
			#player_row.select.connect(select.bind(player))
			player_row.info.connect(info.bind(player))
			player_row.set_up(player, headers, team)
	else :
		var label:Label = Label.new()
		label.text = "NO_PLAYER_FOUND"
		players_container.add_child(label)
		

func _update_page_indicator() -> void:
	page_indicator.text = "%d / %d"%[page + 1, page_max + 1]

func filter(filters: Dictionary, exlusive:bool = false) -> void:
	if filters:
		page = 0
		players = []
		for player in all_players:
			var filter_counter:int = 0
			# because value can be empty
			var valid_filter_counter:int = 0
			for key:String in filters.keys():
				var value:String = str(filters[key])
				if value:
					valid_filter_counter += 1
					if exlusive:
						if not str(value).to_upper() in str(player[key]).to_upper():
							filter_counter += 1
					else:
						if str(value).to_upper() in str(player[key]).to_upper():
							filter_counter += 1
			if filter_counter == valid_filter_counter:
				players.append(player)
	else:
		players = all_players
	_set_up_content()
	page_max = players.size() / page_size
	page = 0
	_update_page_indicator()
	

func info(player:Player) -> void:
	info_player.emit(player)
	
func _sort_attributes(key:String) -> void:
	players.sort_custom(func(a:Player, b:Player) -> bool: return a.attributes.get(info_type).get(key) < b.attributes.get(info_type).get(key))
	
	sort_memory[info_type + "_" + key] = not sort_memory[info_type + "_" + key]
	
	if sort_memory[info_type + "_" + key]:
		players.reverse()
	
	_set_up_content()
	
func _sort_info(key:String) -> void:
	players.sort_custom(func(a:Player, b:Player) -> bool: return a.get(key) < b.get(key))
	
	sort_memory[key] = not sort_memory[key]
	
	if sort_memory[key]:
		players.reverse()
	
	_set_up_content()


func _on_next_2_pressed() -> void:
	page += 5
	if page > page_max:
		page = page_max
	_update_page_indicator()
	_set_up_content()


func _on_next_pressed() -> void:
	page += 1
	if page > page_max:
		page = 0
	_update_page_indicator()
	_set_up_content()


func _on_prev_pressed() -> void:
	page -= 1
	if page < 0:
		page = page_max
	_update_page_indicator()
	_set_up_content()

func _on_prev_2_pressed() -> void:
	page -= 5
	if page < 0:
		page = 0
	_update_page_indicator()
	_set_up_content()
