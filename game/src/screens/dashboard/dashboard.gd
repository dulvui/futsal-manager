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
@onready var visual_calendar:Control = $MainContainer/VBoxContainer/MainView/Content/Calendar
@onready var info:Control = $MainContainer/VBoxContainer/MainView/Content/Info

# labels
@onready var budget_label:Label = $MainContainer/VBoxContainer/TopBar/Budget
@onready var date_label:Label = $MainContainer/VBoxContainer/TopBar/Date
@onready var manager_label:Label = $MainContainer/VBoxContainer/TopBar/ManagerName
@onready var team_label:Label = $MainContainer/VBoxContainer/TopBar/TeamName


enum ContentViews { EMAIL, CALENDAR, TABLE, ALL_PLAYERS, FORMATION, INFO } 

# full screen views
@onready var formation:Control = $MainContainer/VBoxContainer/MainView/Content/Formation
@onready var all_players_list:Control = $MainContainer/VBoxContainer/MainView/Content/AllPlayerList

@onready var player_offer:Control = $PlayerOffer
@onready var contract_offer:Control = $ContractOffer


var match_ready:bool = false
var next_season:bool = false

func _ready() -> void:
	manager_label.text = Config.manager.get_full_name()
	team_label.text = Config.team.name
	date_label.text = Config.calendar().format_date()
	
	all_players_list.set_up(false, true)
	formation.set_up(false)
	
	if Config.calendar().is_match_day():
		continue_button.text = "START_MATCH"
		match_ready = true
		next_match_button.hide()
	else:
		continue_button.text = "NEXT_DAY"
		match_ready = false

			
	if Config.leagues.get_active().calendar.is_season_finished():
		next_season = true
		continue_button.text = "NEXT_SEASON"

	_show_active_view()
		
	

func _process(_delta:float) -> void:
	var email_count:int = EmailUtil.count_unread_messages()
	if email_count > 0:
		email_button.text = "[" + str(EmailUtil.count_unread_messages())  + "] " + tr("EMAIL") 
	else:
		email_button.text = tr("EMAIL")
	budget_label.text = str(team["budget"]) + "" + CurrencyUtil.get_sign()

func _on_Menu_pressed() -> void:
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")

func _on_SearchPlayer_pressed() -> void:
	_show_active_view(ContentViews.ALL_PLAYERS)

func _on_info_pressed() -> void:
	_show_active_view(ContentViews.INFO)

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
	player_offer.set_player(player)
	player_offer.show()
	
func _hide_all() -> void:
	table.hide()
	email.hide()
	visual_calendar.hide()
	formation.hide()
	all_players_list.hide()
	info.hide()

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
			visual_calendar.show()
		ContentViews.FORMATION:
			formation.show()
		ContentViews.ALL_PLAYERS:
			all_players_list.show()
		ContentViews.INFO:
			info.show()
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
	

	# next day in calendar
	for league:League in Config.leagues.list:
		league.calendar.next_day()
	
	# next season check
	if next_season:
		Config.next_season()
		return
	if Config.calendar().is_season_finished():
		next_season = true
		continue_button.text = "NEXT_SEASON"
		return
	
	# general setup
	TransferUtil.update_day()
	email.update_messages()
	date_label.text = Config.calendar().format_date()
	
	# config buttons
	if Config.calendar().is_match_day():
		continue_button.text = "START_MATCH"
		match_ready = true
		next_match_button.disabled = true
		next_match_button.hide()
	else:
		#simulate all other matches
		Config.leagues.random_results()
		
	visual_calendar.set_up()




func _on_email_email_action(message: EmailMessage) -> void:
	if message.type == EmailMessage.Type.CONTRACT_OFFER:
		contract_offer.set_up(TransferUtil.get_transfer_id(message.foreign_id))
		contract_offer.show()
	else:
		print("ERROR: Email action with no type. Text: " + message.text)


func _on_PlayerOffer_hide() -> void:
	player_offer.hide()


func _on_PlayerOffer_confirm() -> void:
	email.update_messages()
	player_offer.hide()


func _on_ContractOffer_cancel() -> void:
	contract_offer.hide()


func _on_ContractOffer_confirm() -> void:
	contract_offer.hide()

