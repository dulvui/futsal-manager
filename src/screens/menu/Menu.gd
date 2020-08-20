extends Control


func _on_StartGame_pressed():
	get_tree().change_scene("res://src/screens/create-manager/CreateManager.tscn")


func _on_Settings_pressed():
	CalendarUtil.next_day()
	MatchMaker.inizialize_matches()


func _on_PlayerList_pressed():
	Leagues.add_random_players()
	get_tree().change_scene("res://src/screens/player-list/PlayerList.tscn")
