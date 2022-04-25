extends Control

const SIZE = 10
var current_page = 0

var headers
var content

var sorter = ContentSort.new()
var sort_memory = {} # to save wich value is already sorted and how


onready var content_container = $MarginContainer/Content
onready var headers_container = $Headers

func _ready():
	pass
	# TEST
#	var test_content = [
#		{
#		"a" : "hans",
#		"b" : 10,
#		"c" : 20
#		},
#		{
#		"a" : "zuis",
#		"b" : 30,
#		"c" : 20
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		},
#		{
#		"a" : "aabb",
#		"b" : 10,
#		"c" : 90
#		}
#	]
#	set_up(test_content, 10)
	
func set_up(_content):
	content = _content
	_set_up_headers()
	_set_up_content()
	
	
func _set_up_headers():
	headers = content[0].keys()
	
	for header in headers:
		sort_memory[header] = "no"
		var button = Button.new()
		button.text = header
		button.connect("button_down",self,"_sort",[header])
		headers_container.add_child(button)
	
func _set_up_content():
	content_container.queue_free()
	content_container = GridContainer.new()
	$MarginContainer.add_child(content_container)
		
	content_container.columns = headers.size()
	for item in content.slice(current_page * SIZE , (current_page * SIZE) + SIZE):
		for value in item.values():
			var label = Label.new()
			label.text = str(value)
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


func _on_Prev_pressed():
	if current_page > 0:
		current_page -= 1
		_set_up_content()
