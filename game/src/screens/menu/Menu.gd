extends Control


func _ready() -> void:
	if DataSaver.team_name == null:
		$CenterContainer/VBoxContainer/Continue.hide()

func _on_StartGame_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/create-manager/CreateManager.tscn")


func _on_Settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/language-pick/LanguagePicker.tscn")


func _on_Continue_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/Dashboard.tscn")
