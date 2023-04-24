extends Control

signal offer_contract

func _ready() -> void:
	update_messages()
	$Message.hide()

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
		button.pressed.connect(show_message.bind(EmailUtil.messages[i]))
		$ScrollContainer/Mails.add_child(button)


func show_message(message) -> void:
	message["read"] = true
	$Message/Action.hide()
	$Message/Subject.text = message["title"]
	$Message/Details/Date.text = message["date"]
	$Message/Details/Sender.text = message["sender"]
	$Message.show()
	
	
	if message["type"] == EmailUtil.MESSAGE_TYPES.CONTRACT_OFFER:
		$Message/Action.text = tr("OFFER_CONTRACT")
		$Message/Action.pressed.connect(show_offer_contract.bind(message["content"]))
		$Message/Message.text = message["message"]
		$Message/Action.show()
	elif message["type"] == EmailUtil.MESSAGE_TYPES.CONTRACT_OFFER_MADE:
		$Message/Message.text = "you made a conttract offer the player"
	#transfer
	else:
		$Message/Message.text = message["message"]
		
	update_messages()


func show_offer_contract(content) -> void:
	emit_signal("offer_contract",content)

func _on_Action_pressed() -> void:
	pass # Replace with function body.


func _on_Close_pressed():
	$Message.hide()
