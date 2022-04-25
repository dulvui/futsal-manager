extends Control

var headers
var content

var sorter = ContentSort.new()


onready var content_container = $ScrollContainer/Content
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
		var button = Button.new()
		button.text = header
		button.connect("button_down",self,"_sort",[header])
		headers_container.add_child(button)
	
func _set_up_content():
	content_container.queue_free()
	content_container = GridContainer.new()
	$ScrollContainer.add_child(content_container)
		
	content_container.columns = headers.size()
	for item in content:
		for value in item.values():
			var label = Label.new()
			label.text = str(value)
			content_container.add_child(label)
	
func _sort(value):
	sorter.value = value
	content.sort_custom(sorter, "sort_ascending")
	_set_up_content()
	


class ContentSort:
	var value
	func sort_ascending(a, b):
		if a[value] < b[value]:
			return true
		return false
