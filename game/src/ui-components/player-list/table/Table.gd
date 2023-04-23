extends Control

signal select_player

const ColorNumber = preload("res://src/ui-components/color-number/ColorNumber.tscn")
const NameLabel = preload("res://src/ui-components/player-list/table/name-label/NameLabel.tscn")
const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

const SIZE = 10

onready var content_container = $MarginContainer/Content
onready var pages = $Pages

var current_page = 0
var max_page = 0

var headers
var content # base content
var current_content # current visible content, can be filtered

var sorter = ContentSort.new()
var sort_memory = {} # to save wich value is already sorted and how

	
func set_up(_headers,_content=null) -> void:
	headers = _headers
	
	# if content, table is setup for first time
	# else headers are changed
	if _content:
		content = _content
		current_content = content
		
		# flatten attributes
		for item in content:
			for key in item["attributes"]["mental"].keys():
				item[key] = item["attributes"]["mental"][key]
			for key in item["attributes"]["physical"].keys():
				item[key] = item["attributes"]["physical"][key]
			for key in item["attributes"]["technical"].keys():
				item[key] = item["attributes"]["technical"][key]
			for key in item["attributes"]["goalkeeper"].keys():
				item[key] = item["attributes"]["goalkeeper"][key]
				
	# set up sort memory
	for header in headers:
		sort_memory[header] = "no"
		
	_set_up_content()
	


func _set_up_headers() -> void:
	for header in headers:
		var button = Button.new()
		button.text = header.substr(0,3)
		button.connect("button_down",self,"_sort",[header])
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
	content_container.queue_free()
	content_container = GridContainer.new()
	$MarginContainer.add_child(content_container)
	
	_update_max_page()
	_set_up_headers()
	
	content_container.columns = headers.size() + 2 # +2 for info and change button
	for item in current_content.slice(current_page * SIZE , (current_page * SIZE) + SIZE):
		for header in headers:
			var label
			if typeof(item[header]) == 3:
				label = ColorNumber.instantiate()
				label.set_up(item[header])
			else:
				label = NameLabel.instantiate()
				label.set_name(item[header])
			content_container.add_child(label)
			
		#info button
		var button = Button.new()
		button.text = "info"
		button.connect("button_down",self,"show_info",[item])
		content_container.add_child(button)
		
		#change button
		var button_change = Button.new()
		button_change.text = "chose"
		button_change.connect("button_down",self,"change_player",[item])
		content_container.add_child(button_change)
		
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
	var player_profile = PlayerProfile.instantiate()
	add_child(player_profile)
	player_profile.set_up_info(player)
	
func change_player(player) -> void:
	emit_signal("select_player",player)
	
func _sort(value) -> void:
	sorter.value = value
	current_content.sort_custom(sorter, _get_sorting(value))
	_set_up_content()
	
func _get_sorting(value) -> String:
	if sort_memory[value] == "ascending":
		sort_memory[value] = "descending"
	else:
		sort_memory[value] = "ascending"
	return sort_memory[value]

class ContentSort:
	var value
	func ascending(a, b) -> bool:
		if a[value] < b[value]:
			return true
		return false
		
	func descending(a, b) -> bool:
		if a[value] > b[value]:
			return true
		return false


func _on_Next_pressed() -> void:
	if current_page < max_page - 1:
		current_page += 1
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
	
