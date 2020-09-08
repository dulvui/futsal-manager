extends Control

func _ready():
	for message in EmailUtil.messages:
		var title_label = Label.new()
		title_label.text = message["title"]
		$ScrollContainer/Mails.add_child(title_label)
		
		var button = Button.new()
		button.text = "READ"
		button.connect("pressed",self,"show_message",[message])
		$ScrollContainer/Mails.add_child(button)

func update_messages():
	for child in $ScrollContainer/Mails.get_children():
		child.queue_free()
	
	for message in EmailUtil.messages:
		var title_label = Label.new()
		title_label.text = message["title"]
		$ScrollContainer/Mails.add_child(title_label)
		
		var button = Button.new()
		button.text = "READ"
		button.connect("pressed",self,"show_message",[message])
		$ScrollContainer/Mails.add_child(button)


func show_message(message):
	$DetailPopUp/Title.text = message["title"]
	$DetailPopUp/Message.text = message["message"]
	$DetailPopUp.popup_centered()
