extends Control

onready var team = DataSaver.get_selected_team()


func _ready():
	$ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$TeamName.text = DataSaver.selected_team
#	$Buttons/Manager.text =  DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	
	$Date.text = CalendarUtil.get_date()
	$AllPlayerList.set_up()
	

func _process(_delta):
	$Buttons/Email/Panel/MailCounter.text = str(EmailUtil.count_unread_messages())
	$Budget.text = str(team["budget"])

func _on_Menu_pressed():
	get_tree().change_scene("res://src/screens/menu/Menu.tscn")


func _on_SearchPlayer_pressed():
	$AllPlayerList.show()


func _on_Training_pressed():
	$TrainingPopup.popup_centered()


func _on_Formation_pressed():
	$Formation.show()


func _on_Continue_pressed():
	CalendarUtil.next_day()
	TransferUtil.update_day()
	$Email.update_messages()
	$Calendar.set_up()
	$Date.text = CalendarUtil.get_date()
	$Formation/PlayerList.add_subs()
	DataSaver.save_all_data()
	if DataSaver.calendar[DataSaver.month][DataSaver.day]["matches"].size() > 0:
		get_tree().change_scene("res://src/screens/match/Match.tscn")

func _on_Email_pressed():
	_hide_all()
	$Email.show()

func _on_Table_pressed():
	_hide_all()
	$Table.show()
	
func _on_Calendar_pressed():
	_hide_all()
	$Calendar.show()


func _on_AllPlayerList_select_player(player):
	print("offer for " + player["surname"])
	$PlayerOfferPopup/PlayerOffer.set_player(player)
	$PlayerOfferPopup/PlayerOffer.show()
	$PlayerOfferPopup.popup_centered()


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


func _on_ContractOffer_confirm():
	$Email.update_messages()
	$ContractPopup.hide()
	
func _hide_all():
	$Table.hide()
	$Email.hide()
	$Calendar.hide()
