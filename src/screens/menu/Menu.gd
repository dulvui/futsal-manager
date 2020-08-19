extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGame_pressed():
	get_tree().change_scene("res://src/screens/create-manager/CreateManager.tscn")


func _on_Settings_pressed():
	for i in range(30):
		CalendarUtil.next_day()
