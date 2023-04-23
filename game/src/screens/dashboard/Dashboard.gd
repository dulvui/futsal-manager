extends Control

@onready
var team = DataSaver.get_selected_team()

var match_ready:bool = false
var next_season:bool = false

func _ready() -> void:
	$ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$TeamName.text = DataSaver.team_name
#	$Buttons/Manager.text =  DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	
	$Date.text = CalendarUtil.get_dashborad_date()
	$AllPlayerList.set_up(true)
	
	$Formation.set_up()
	
	if DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"].size() > 0:
		if DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"][0]["result"].length() > 1:
			$Continue.text = "CONTINUE"
			match_ready = false
		else:
			$Continue.text = "START_MATCH"
			match_ready = true
			
	if DataSaver.date.month == CalendarUtil.END_MONTH and DataSaver.date.day == CalendarUtil.END_DAY:
		next_season = true
		$Continue.text = "NEXT_SEASON"
		
	

func _process(_delta) -> void:
	$Buttons/Email/Panel/MailCounter.text = str(EmailUtil.count_unread_messages())
	$Budget.text = str(team["budget"])

func _on_Menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")


func _on_SearchPlayer_pressed() -> void:
	$AllPlayerList.show()


func _on_Training_pressed() -> void:
	$TrainingPopup.popup_centered()


func _on_Formation_pressed() -> void:
	$Formation.show()


func _on_Continue_pressed() -> void:
	if match_ready:
		get_tree().change_scene_to_file("res://src/screens/match/Match.tscn")
		return
	
	if next_season:
		DataSaver.next_season()
		return
	
	if DataSaver.date.month == CalendarUtil.END_MONTH and DataSaver.date.day == CalendarUtil.END_DAY:
		next_season = true
		$Continue.text = "NEXT_SEASON"
		return
		

	CalendarUtil.next_day()
	TransferUtil.update_day()
	$Email.update_messages()
	$Calendar.set_up()
	$Date.text = CalendarUtil.get_dashborad_date()
	# increases mobile performance not saving on every continue
	#DataSaver.save_all_data()
	if DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"].size() > 0:
		$Continue.text = "START_MATCH"
		match_ready = true


func _on_Email_pressed() -> void:
	_hide_all()
	$Email.show()

func _on_Table_pressed() -> void:
	_hide_all()
	$Table.show()
	
func _on_Calendar_pressed() -> void:
	_hide_all()
	$Calendar.show()


func _on_AllPlayerList_select_player(player) -> void:
	print("offer for " + player["surname"])
	$PlayerOfferPopup/PlayerOffer.set_player(player)
	$PlayerOfferPopup/PlayerOffer.show()
	$PlayerOfferPopup.popup_centered()


func _on_PlayerOffer_hide() -> void:
	$PlayerOfferPopup.hide()


func _on_PlayerOffer_confirm() -> void:
	$Email.update_messages()
	$PlayerOfferPopup.hide()


func _on_Email_offer_contract(content) -> void:
	print("contract content")
	print(content)
	$ContractPopup/ContractOffer.set_up(content)
	$ContractPopup.popup_centered()


func _on_ContractOffer_cancel() -> void:
	$ContractPopup.hide()


func _on_ContractOffer_confirm() -> void:
	$Email.update_messages()
	$ContractPopup.hide()
	
func _hide_all() -> void:
	$Table.hide()
	$Email.hide()
	$Calendar.hide()
