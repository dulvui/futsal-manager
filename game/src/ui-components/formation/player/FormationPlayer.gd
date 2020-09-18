extends Control

signal change_player

var player


func set_player(new_player):
	player = new_player
	$Name.text = player["surname"]
	$Nr.text = str(player["nr"])


func _on_Change_pressed():
	emit_signal("change_player",player)
