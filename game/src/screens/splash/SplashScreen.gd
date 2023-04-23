extends Control

func _ready() -> void:
	if DataSaver.language == "ND":
		get_tree().change_scene_to_file("res://src/screens/language-pick/LanguagePicker.tscn")
	else:
		get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")
