extends Control


func _ready():
	if not DataSaver.season_started:
		$CenterContainer/VBoxContainer/Continue.hide()

func _on_StartGame_pressed():
	DataSaver.reset()
	get_tree().change_scene("res://src/screens/create-manager/CreateManager.tscn")


func _on_Settings_pressed():
	pass



func _on_Continue_pressed():
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")
