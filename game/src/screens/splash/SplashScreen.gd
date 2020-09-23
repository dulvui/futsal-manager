extends Control

func _ready():
	if DataSaver.language == "ND":
		get_tree().change_scene("res://src/screens/language-pick/LanguagePicker.tscn")
	else:
		get_tree().change_scene("res://src/screens/menu/Menu.tscn")
