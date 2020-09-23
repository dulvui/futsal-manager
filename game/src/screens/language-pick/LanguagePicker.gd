extends Control


func _on_English_pressed():
	DataSaver.set_lang("en")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Portuguese_pressed():
	DataSaver.set_lang("pt")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Italian_pressed():
	DataSaver.set_lang("it")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_German_pressed():
	DataSaver.set_lang("de")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Spanish_pressed():
	DataSaver.set_lang("es")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")
