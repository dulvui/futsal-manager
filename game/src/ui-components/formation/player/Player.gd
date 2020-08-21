extends Control


func set_player(player):
	$Name.text = player["surname"]
	$Nr.text = str(player["nr"])
