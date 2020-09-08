extends Control

func _ready():
	for message in EmailUtil.messages:
		var title_label = Label.new()
		title_label.text = message["title"]
		$ScrollContainer/Mails.add_child(title_label)
