extends Control


func _on_English_pressed():
	DataSaver.set_lang("en")
	next_screen()


func _on_Portuguese_pressed():
	DataSaver.set_lang("pt")
	next_screen()


func _on_Italian_pressed():
	DataSaver.set_lang("it")
	next_screen()


func _on_German_pressed():
	DataSaver.set_lang("de")
	next_screen()


func _on_Spanish_pressed():
	DataSaver.set_lang("es")
	next_screen()
	
func next_screen():
	if DataSaver.gdpr_consent == DataSaver.GDPR_CONSENTS.ND:
		get_tree().change_scene("res://src/screens/gdpr-consent/GDPRConsent.tscn")
	else:
		get_tree().change_scene("res://src/screens/menu/Menu.tscn")
