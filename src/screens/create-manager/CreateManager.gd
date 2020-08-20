extends Control


func _ready():
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Continue_pressed():
	if $GridContainer/Name.text.length() * $GridContainer/SurName.text.length() * $GridContainer/Nat.text.length() > 0:
		var manager = {
			"name" : $GridContainer/Name.text,
			"surname" :$GridContainer/SurName.text,
			"nationality" : $GridContainer/Nat.text 
		}
		DataSaver.save_manager(manager)
		get_tree().change_scene("res://src/ui-components/team-select/TeamSelect.tscn")
