extends Control

@onready
var team:Dictionary = DataSaver.get_selected_team()

@onready
var continue_button:Button = $Main/VBoxContainer/HSplitContainer/Buttons/Continue

@onready
var next_match_button:Button = $Main/VBoxContainer/HSplitContainer/Buttons/NextMatch

var match_ready:bool = false
var next_season:bool = false

func _ready() -> void:
	$Main/VBoxContainer/TopBar/ManagerName.text = DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	$Main/VBoxContainer/TopBar/TeamName.text = DataSaver.team_name
	$Main/VBoxContainer/TopBar/Date.text = CalendarUtil.get_dashborad_date()
#	$Buttons/Manager.text =  DataSaver.manager["name"] + " " + DataSaver.manager["surname"]
	
	$AllPlayerList.set_up(true)
	$Formation.set_up()
	
	if DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"].size() > 0:
		if DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"][0]["result"].length() > 1:
			continue_button.text = "CONTINUE"
			match_ready = false
		else:
			continue_button.text = "START_MATCH"
			match_ready = true
			
	if DataSaver.date.month == CalendarUtil.END_MONTH and DataSaver.date.day == CalendarUtil.END_DAY:
		next_season = true
		continue_button.text = "NEXT_SEASON"
		
	

func _process(_delta) -> void:
	$Main/VBoxContainer/HSplitContainer/Buttons/Email/Counter.text = str(EmailUtil.count_unread_messages())
	$Main/VBoxContainer/TopBar/Budget.text = str(team["budget"])

func _on_Menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")


func _on_SearchPlayer_pressed() -> void:
	$AllPlayerList.show()


func _on_Training_pressed() -> void:
	$TrainingPopup.popup_centered()


func _on_Formation_pressed() -> void:
	$Formation.show()

func _on_Email_pressed() -> void:
	_hide_all()
	$Main/VBoxContainer/HSplitContainer/Content/Email.show()

func _on_Table_pressed() -> void:
	_hide_all()
	$Main/VBoxContainer/HSplitContainer/Content/Table.show()
	
func _on_Calendar_pressed() -> void:
	_hide_all()
	$Main/VBoxContainer/HSplitContainer/Content/Calendar.show()


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
	$Main/VBoxContainer/HSplitContainer/Content/Email.update_messages()
	$ContractPopup.hide()
	
func _hide_all() -> void:
	$Main/VBoxContainer/HSplitContainer/Content/Table.hide()
	$Main/VBoxContainer/HSplitContainer/Content/Email.hide()
	$Main/VBoxContainer/HSplitContainer/Content/Calendar.hide()

func _on_Continue_pressed() -> void:
	_next_day()

func _on_next_match_pressed():
	next_match_button.disabled = true
	continue_button.disabled = true
	
	while not match_ready:
		_next_day()
		var timer = Timer.new()
		add_child(timer)
		timer.start(1)
		await timer.timeout
		
	next_match_button.disabled = false
	continue_button.disabled = false
	

func _next_day() -> void:
	if match_ready:
		get_tree().change_scene_to_file("res://src/screens/match/Match.tscn")
		return
	
	if next_season:
		DataSaver.next_season()
		return
	
	if DataSaver.date.month == CalendarUtil.END_MONTH and DataSaver.date.day == CalendarUtil.END_DAY:
		next_season = true
		continue_button.text = "NEXT_SEASON"
		return
		

	CalendarUtil.next_day()
	TransferUtil.update_day()
	$Main/VBoxContainer/HSplitContainer/Content/Email.update_messages()
	$Main/VBoxContainer/HSplitContainer/Content/Calendar.set_up()
	$Main/VBoxContainer/TopBar/Date.text = CalendarUtil.get_dashborad_date()
	if DataSaver.calendar[DataSaver.date.month][DataSaver.date.day]["matches"].size() > 0:
		continue_button.text = "START_MATCH"
		match_ready = true
		next_match_button.disabled = true
