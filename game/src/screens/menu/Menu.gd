extends Control


func _ready():
	if DataSaver.selected_team == "":
		$CenterContainer/VBoxContainer/Continue.hide()

func _on_StartGame_pressed():
	get_tree().change_scene("res://src/screens/create-manager/CreateManager.tscn")


func _on_Settings_pressed():
	get_tree().change_scene("res://src/screens/language-pick/LanguagePicker.tscn")



func _on_Continue_pressed():
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")
