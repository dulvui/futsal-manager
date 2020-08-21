extends Control


func _ready():
	$ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$TeamName.text = DataSaver.team["name"]
	$Buttons/Manager.text =  DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	
	$PlayerPopUp/PlayerList.add_players(DataSaver.team["players"])
	$AllPlayersPopup/AllPlayerList.add_players(Players.players)
	
	$Date.text = CalendarUtil.get_date()




func _on_Team_pressed():
	$PlayerPopUp.popup_centered()


func _on_Calendar_pressed():
	$CalendarPopup.popup_centered()


func _on_Menu_pressed():
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_Manager_pressed():
	pass # Replace with function body.




func _on_SearchPlayer_pressed():
	$AllPlayersPopup.popup_centered()


func _on_Training_pressed():
	pass # Replace with function body.


func _on_Formation_pressed():
	$FormationPopUp.popup_centered()
