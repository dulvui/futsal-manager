extends Control

onready var team = DataSaver.get_selected_team()


func _ready():
	$ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$TeamName.text = DataSaver.selected_team
#	$Buttons/Manager.text =  DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	
	
	$AllPlayersPopup/AllPlayerList.add_all_players(false)
	$FormationPopUp/Formation/PlayerSelect/PlayerList.add_players()
	
	$Date.text = CalendarUtil.get_date()
	

func _process(delta):
	$Buttons/Email/Panel/MailCounter.text = str(EmailUtil.count_unread_messages())
	$Budget.text = str(team["budget"])

func _on_Menu_pressed():
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_SearchPlayer_pressed():
	$AllPlayersPopup.popup_centered()


func _on_Training_pressed():
	$TrainingPopup.popup_centered()


func _on_Formation_pressed():
	$FormationPopUp.popup_centered()


func _on_Continue_pressed():
	CalendarUtil.next_day()
	TransferUtil.update_day()
	$Email.update_messages()
	$Date.text = CalendarUtil.get_date()
	$FormationPopUp/Formation/PlayerSelect/PlayerList.add_players()
	DataSaver.save_all_data()
	if DataSaver.calendar[CalendarUtil.day_counter]["matches"].size() > 0:
		get_tree().change_scene("res://src/screens/match/Match.tscn")

func _on_Email_pressed():
	$Calendar.hide()
	$Email.show()


func _on_Table_pressed():
	$TablePopup.popup_centered()


func _on_AllPlayerList_select_player(player):
	print("offer for " + player["surname"])
	$PlayerOfferPopup/PlayerOffer.set_player(player)
	$PlayerOfferPopup/PlayerOffer.show()
	$PlayerOfferPopup.popup_centered()
#	TransferUtil.make_offer(player,4200)
#	$EmailPopup/Email.update_messages()


func _on_PlayerOffer_hide():
	$PlayerOfferPopup.hide()


func _on_PlayerOffer_confirm():
	$Email.update_messages()
	$PlayerOfferPopup.hide()


func _on_Email_offer_contract(content):
	print("contract content")
	print(content)
	$ContractPopup/ContractOffer.set_up(content)
	$ContractPopup.popup_centered()


func _on_ContractOffer_cancel():
	$ContractPopup.hide()


func _on_Calendar_pressed():
	$Email.hide()
	$Calendar.show()


func _on_ContractOffer_confirm():
	$Email.update_messages()
	$ContractPopup.hide()
