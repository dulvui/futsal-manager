extends Control

signal change_player

var player:Dictionary


func set_player(new_player:Dictionary) -> void:
	player = new_player
	$Name.text = player["surname"]
	$Nr.text = str(player["nr"])


func _on_Change_pressed() -> void:
	emit_signal("change_player",player)
