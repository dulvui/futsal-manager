extends Control

const ColorNumber = preload("res://src/ui-components/color-number/ColorNumber.tscn")
const NameLabel = preload("res://src/ui-components/player-list/table/name-label/NameLabel.tscn")


const SIZE = 10

onready var content_container = $MarginContainer/Content
onready var pages = $Pages


var current_page = 0

var headers
var content

var sorter = ContentSort.new()
var sort_memory = {} # to save wich value is already sorted and how

	
func set_up(_content, _headers):
	content = _content
	headers = _headers
	
		
	# flatten attributes
	for item in content:
		for key in item["attributes"]["mental"].keys():
			item[key] = item["attributes"]["mental"][key]
		for key in item["attributes"]["physical"].keys():
			item[key] = item["attributes"]["physical"][key]
		for key in item["attributes"]["technical"].keys():
			item[key] = item["attributes"]["technical"][key]
		for key in item["attributes"]["goal_keeper"].keys():
			item[key] = item["attributes"]["goal_keeper"][key]
		item.erase("attribute")
		
	_set_up_content()
	
	# set up sort memory
	for header in headers:
		sort_memory[header] = "no"
	
	pages.text = "1/" + str((content.size()/SIZE) + 1)

func _set_up_headers():
	for header in headers:
		var button = Button.new()
		button.text = header.substr(0,4)
		button.connect("button_down",self,"_sort",[header])
		content_container.add_child(button)
	
func _set_up_content():
	content_container.queue_free()
	content_container = GridContainer.new()
	$MarginContainer.add_child(content_container)
	
	_set_up_headers()
	
	content_container.columns = headers.size()
	for item in content.slice(current_page * SIZE , (current_page * SIZE) + SIZE):
		for header in headers:
			var label
			if typeof(item[header]) == 3:
				label = ColorNumber.instance()
				label.set_up(item[header])
			else:
				label = NameLabel.instance()
				label.set_name(item[header])
			content_container.add_child(label)
	
func _sort(value):
	sorter.value = value
	content.sort_custom(sorter, _get_sorting(value))
	_set_up_content()
	
func _get_sorting(value):
	if sort_memory[value] == "ascending":
		sort_memory[value] = "descending"
	else:
		sort_memory[value] = "ascending"
	return sort_memory[value]

class ContentSort:
	var value
	func ascending(a, b):
		if a[value] < b[value]:
			return true
		return false
		
	func descending(a, b):
		if a[value] > b[value]:
			return true
		return false


func _on_Next_pressed():
	if current_page < content.size() / SIZE:
		current_page += 1
		_set_up_content()
	pages.text = str(current_page + 1) + "/" + str((content.size()/SIZE) + 1)


func _on_Prev_pressed():
	if current_page > 0:
		current_page -= 1
		_set_up_content()
	pages.text = str(current_page + 1) + "/" + str((content.size()/SIZE) + 1)

