# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var team:Team = Config.team

# buttons
@onready var continue_button:Button = $MainContainer/VBoxContainer/MainView/Buttons/Continue
@onready var next_match_button:Button = $MainContainer/VBoxContainer/MainView/Buttons/NextMatch
@onready var email_button:Button = $MainContainer/VBoxContainer/MainView/Buttons/Email

# content views 
@onready var email:Control = $MainContainer/VBoxContainer/MainView/Content/Email
@onready var table:Control = $MainContainer/VBoxContainer/MainView/Content/Table
@onready var calendar:Control = $MainContainer/VBoxContainer/MainView/Content/Calendar

# labels
@onready var budget_label:Label = $MainContainer/VBoxContainer/TopBar/Budget

enum ContentViews { EMAIL, CALENDAR, TABLE, ALL_PLAYERS, FORMATION } 

# full screen views
@onready var formation:Control = $MainContainer/VBoxContainer/MainView/Content/Formation
@onready var all_players_list:Control = $MainContainer/VBoxContainer/MainView/Content/AllPlayerList


var match_ready:bool = false
var next_season:bool = false

func _ready() -> void:
	$MainContainer/VBoxContainer/TopBar/ManagerName.text = Config.manager["name"] + " " + Config.manager["surname"]
	$MainContainer/VBoxContainer/TopBar/TeamName.text = Config.team.name
	$MainContainer/VBoxContainer/TopBar/Date.text = CalendarUtil.get_dashborad_date()
	
	all_players_list.set_up(true, false)
	formation.set_up()
	
	if Config.calendar[Config.date.month][Config.date.day]["matches"].size() > 0:
		if Config.calendar[Config.date.month][Config.date.day]["matches"][0]["result"].length() > 1:
			continue_button.text = "NEXT_DAY"
			match_ready = false
		else:
			continue_button.text = "START_MATCH"
			match_ready = true
			
	if Config.date.month == CalendarUtil.END_MONTH and Config.date.day == CalendarUtil.END_DAY:
		next_season = true
		continue_button.text = "NEXT_SEASON"

	_show_active_view()
		
	

func _process(_delta:float) -> void:
	var email_count:int = EmailUtil.count_unread_messages()
	if email_count > 0:
		email_button.text = str(EmailUtil.count_unread_messages())  + " " + tr("EMAIL") 
	else:
		email_button.text = tr("EMAIL")
	budget_label.text = str(team["budget"]) + "" + CurrencyUtil.get_sign()

func _on_Menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_Training_pressed() -> void:
	$TrainingPopup.popup_centered()

func _on_SearchPlayer_pressed() -> void:
	_show_active_view(ContentViews.ALL_PLAYERS)

func _on_Formation_pressed() -> void:
	_show_active_view(ContentViews.FORMATION)

func _on_Email_pressed() -> void:
	_show_active_view(ContentViews.EMAIL)

func _on_Table_pressed() -> void:
	_show_active_view(ContentViews.TABLE)
	
func _on_Calendar_pressed() -> void:
	_show_active_view(ContentViews.CALENDAR)


func _on_all_player_list_select_player(player:Player) -> void:
	print("offer for " + player.surname)
	$PlayerOfferPopup/PlayerOffer.set_player(player)
	$PlayerOfferPopup/PlayerOffer.show()
	$PlayerOfferPopup.popup_centered()


func _on_PlayerOffer_hide() -> void:
	$PlayerOfferPopup.hide()


func _on_PlayerOffer_confirm() -> void:
	$Email.update_messages()
	$PlayerOfferPopup.hide()


func _on_Email_offer_contract(content:Dictionary) -> void:
	print("contract content")
	print(content)
	$ContractPopup/ContractOffer.set_up(content)
	$ContractPopup.popup_centered()


func _on_ContractOffer_cancel() -> void:
	$ContractPopup.hide()


func _on_ContractOffer_confirm() -> void:
	email.update_messages()
	$ContractPopup.hide()
	
func _hide_all() -> void:
	table.hide()
	email.hide()
	calendar.hide()
	formation.hide()
	all_players_list.hide()

func _show_active_view(active_view:int=-1) -> void:
	_hide_all()
	if active_view > -1:
		Config.dashboard_active_content = active_view

	match Config.dashboard_active_content:
		ContentViews.EMAIL:
			email.show()
		ContentViews.TABLE:
			table.show()
		ContentViews.CALENDAR:
			calendar.show()
		ContentViews.FORMATION:
			formation.show()
		ContentViews.ALL_PLAYERS:
			all_players_list.show()
		_:
			email.show()

func _on_Continue_pressed() -> void:
	_next_day()
	# remove comment to test player progress
	# PlayerProgress.update_players()

func _on_next_match_pressed() -> void:
	next_match_button.disabled = true
	continue_button.disabled = true
	
	while not match_ready:
		_next_day()
		var timer:Timer = Timer.new()
		add_child(timer)
		timer.start(Constants.DASHBOARD_DAY_DELAY)
		await timer.timeout
		
	next_match_button.disabled = false
	continue_button.disabled = false
	

func _next_day() -> void:
	if match_ready:
		get_tree().change_scene_to_file("res://src/screens/match/match.tscn")
		return
	
	if next_season:
		Config.next_season()
		return
	
	if Config.date.month == CalendarUtil.END_MONTH and Config.date.day == CalendarUtil.END_DAY:
		next_season = true
		continue_button.text = "NEXT_SEASON"
		return

	CalendarUtil.next_day()
	TransferUtil.update_day()
	email.update_messages()
	calendar.set_up(true)
	$MainContainer/VBoxContainer/TopBar/Date.text = CalendarUtil.get_dashborad_date()
	if Config.calendar[Config.date.month][Config.date.day]["matches"].size() > 0:
		continue_button.text = "START_MATCH"
		match_ready = true
		next_match_button.disabled = true


