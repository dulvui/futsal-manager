extends ScrollContainer

@onready
var vbox:VBoxContainer = $VBoxContainer

func append_text(text:String) -> void:
	var label = Label.new()
	label.text = text
	vbox.add_child(label)
