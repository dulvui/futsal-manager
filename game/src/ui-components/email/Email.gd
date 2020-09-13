extends Control

signal offer_contract

func _ready():
	for message in EmailUtil.messages:
		var title_label = Label.new()
		title_label.text = message["title"]
		$ScrollContainer/Mails.add_child(title_label)
		
		var button = Button.new()
		if message["read"]:
			button.text = "READ"
		else:
			button.text = "*READ*"
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
		if message["read"]:
			button.text = "READ"
		else:
			button.text = "*READ*"
		button.connect("pressed",self,"show_message",[message])
		$ScrollContainer/Mails.add_child(button)


func show_message(message):
	message["read"] = true
	
	
	if message["type"] == "CONTRACT":
		$DetailPopUp/Action.text = tr("OFFER_CONTRACT")
		$DetailPopUp/Action.connect("pressed",self,"show_offer_contract",[message["content"]])
		$DetailPopUp/Message.text = message["message"]
	elif message["type"] == "CONTRACT_SIGNED":
		$DetailPopUp/Message.text = "you sigfned the player"
	$DetailPopUp/Title.text = message["title"]
	$DetailPopUp.popup_centered()

func show_offer_contract(content):
	emit_signal("offer_contract",content)

func _on_Action_pressed():
	pass # Replace with function body.
