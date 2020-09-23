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
	$DetailPopUp/Action.hide()
	$DetailPopUp/Title.text = message["title"]
	$DetailPopUp.popup_centered()
	
	
	if message["type"] == EmailUtil.MESSAGE_TYPES.CONTRACT_OFFER:
		$DetailPopUp/Action.text = tr("OFFER_CONTRACT")
		$DetailPopUp/Action.connect("pressed",self,"show_offer_contract",[message["content"]])
		$DetailPopUp/Message.text = message["message"]
		$DetailPopUp/Action.show()
	elif message["type"] == EmailUtil.MESSAGE_TYPES.CONTRACT_OFFER_MADE:
		$DetailPopUp/Message.text = "you made a conttract offer the player"
	#transfer
	else:
		$DetailPopUp/Message.text = message["message"]


func show_offer_contract(content):
	emit_signal("offer_contract",content)

func _on_Action_pressed():
	pass # Replace with function body.
