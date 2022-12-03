extends Control

signal offer_contract

func _ready() -> void:
	update_messages()

func update_messages() -> void:
	for child in $ScrollContainer/Mails.get_children():
		child.queue_free()
	
	for i in range(EmailUtil.messages.size()-1,-1,-1): # reverse list
		var title_label = Label.new()
		title_label.text = EmailUtil.messages[i]["title"]
		$ScrollContainer/Mails.add_child(title_label)
		
		var button = Button.new()
		if EmailUtil.messages[i]["read"]:
			button.text = "READ"
		else:
			button.text = "*READ*"
		button.connect("pressed",self,"show_message",[EmailUtil.messages[i]])
		$ScrollContainer/Mails.add_child(button)


func show_message(message) -> void:
	message["read"] = true
	$DetailPopUp/Action.hide()
	$DetailPopUp/Subject.text = message["title"]
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
		
	update_messages()


func show_offer_contract(content) -> void:
	emit_signal("offer_contract",content)

func _on_Action_pressed() -> void:
	pass # Replace with function body.


func _on_Close_pressed():
	$DetailPopUp.hide()
