extends Control


func _ready():
	$ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$TeamName.text = DataSaver.team["name"]
#	$Buttons/Manager.text =  DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	
	$AllPlayersPopup/AllPlayerList.add_all_players()
	
	$Date.text = CalendarUtil.get_date()
	
	
	
func _on_Team_pressed():
	$PlayerPopUp.popup_centered()


func _on_Menu_pressed():
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_SearchPlayer_pressed():
	$AllPlayersPopup.popup_centered()


func _on_Training_pressed():
	pass # Replace with function body.


func _on_Formation_pressed():
	$FormationPopUp.popup_centered()


func _on_Continue_pressed():
	CalendarUtil.next_day()
	$Date.text = CalendarUtil.get_date()
	DataSaver.save_all_data()
	if DataSaver.calendar[CalendarUtil.day_counter]["matches"].size() > 0:
		get_tree().change_scene("res://src/screens/match/Match.tscn")

func _on_Email_pressed():
	$EmailPopup.popup_centered()


func _on_Table_pressed():
	$TablePopup.popup_centered()
