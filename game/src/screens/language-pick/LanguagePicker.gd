extends Control


func _on_English_pressed():
	DataSaver.set_lang("EN")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Portuguese_pressed():
	DataSaver.set_lang("PR")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Italian_pressed():
	DataSaver.set_lang("IT")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_German_pressed():
	DataSaver.set_lang("GER")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Spanish_pressed():
	DataSaver.set_lang("ES")
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")
