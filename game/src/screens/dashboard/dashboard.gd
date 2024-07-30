# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

enum ContentViews { 
	EMAIL,
	CALENDAR,
	TABLE,
	PLAYERS,
	ALL_PLAYERS,
	FORMATION,
	INFO,
	PLAYER_OFFER,
	CONTRACT_OFFER,
	PLAYER_PROFILE,
}

const DASHBOARD_DAY_DELAY: float = 0.5

@onready var team: Team = Config.team

# buttons
@onready var continue_button: Button = $MainContainer/VBoxContainer/MainView/Buttons/Continue
@onready var next_match_button: Button = $MainContainer/VBoxContainer/MainView/Buttons/NextMatch
@onready var email_button: Button = $MainContainer/VBoxContainer/MainView/Buttons/Email

# content views
@onready var email: VisualEmail = $MainContainer/VBoxContainer/MainView/Content/Email
@onready var table: VisualTable = $MainContainer/VBoxContainer/MainView/Content/Table
@onready var visual_calendar: VisualCalendar = $MainContainer/VBoxContainer/MainView/Content/Calendar
@onready var info: VisualInfo = $MainContainer/VBoxContainer/MainView/Content/Info

# labels
@onready var budget_label: Label = $MainContainer/VBoxContainer/TopBar/Budget
@onready var date_label: Label = $MainContainer/VBoxContainer/TopBar/Date
@onready var manager_label: Label = $MainContainer/VBoxContainer/TopBar/ManagerName
@onready var team_label: Label = $MainContainer/VBoxContainer/TopBar/TeamName

# full screen views
@onready var formation: VisualFormation = $MainContainer/VBoxContainer/MainView/Content/Formation
@onready var player_list: PlayerList = $MainContainer/VBoxContainer/MainView/Content/PlayerList
@onready var all_players_list: PlayerList = $MainContainer/VBoxContainer/MainView/Content/AllPlayerList
@onready var player_offer: PlayerOffer = $MainContainer/VBoxContainer/MainView/Content/PlayerOffer
@onready var contract_offer: ContractOffer = $MainContainer/VBoxContainer/MainView/Content/ContractOffer
@onready var player_profile: PlayerProfile = $MainContainer/VBoxContainer/MainView/Content/PlayerProfile

var match_ready: bool = false
var next_season: bool = false

var view_history: Array[ContentViews]
var view_history_index: int = 0
var active_view:ContentViews = 0


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	manager_label.text = Config.manager.get_full_name()
	team_label.text = Config.team.name
	date_label.text = Config.calendar().format_date()
	
	all_players_list.set_up()
	player_list.set_up(Config.team.id)
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


func _process(_delta: float) -> void:
	var email_count: int = EmailUtil.count_unread_messages()
	if email_count > 0:
		email_button.text = "[" + str(EmailUtil.count_unread_messages()) + "] " + tr("EMAIL")
	else:
		email_button.text = tr("EMAIL")
	budget_label.text = FormatUtil.get_sign(team.budget)


func _on_menu_pressed() -> void:
	Config.save_all_data()
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_search_player_pressed() -> void:
	_show_active_view(ContentViews.ALL_PLAYERS)


func _on_info_pressed() -> void:
	_show_active_view(ContentViews.INFO)


func _on_formation_pressed() -> void:
	_show_active_view(ContentViews.FORMATION)


func _on_email_pressed() -> void:
	_show_active_view(ContentViews.EMAIL)


func _on_table_pressed() -> void:
	_show_active_view(ContentViews.TABLE)


func _on_calendar_pressed() -> void:
	_show_active_view(ContentViews.CALENDAR)


func _on_players_pressed() -> void:
	_show_active_view(ContentViews.PLAYERS)


func _on_all_player_list_select_player(player: Player) -> void:
	player_profile.set_player(player)
	_show_active_view(ContentViews.PLAYER_PROFILE)


func _on_player_list_select_player(player: Player) -> void:
	player_profile.set_player(player)
	_show_active_view(ContentViews.PLAYER_PROFILE)


func _on_player_profile_select(player: Player) -> void:
	player_offer.set_player(player)
	_show_active_view(ContentViews.PLAYER_OFFER)


func _on_player_profile_cancel() -> void:
	_show_active_view(ContentViews.ALL_PLAYERS)


func _hide_all() -> void:
	table.hide()
	email.hide()
	visual_calendar.hide()
	formation.hide()
	all_players_list.hide()
	player_list.hide()
	info.hide()
	player_offer.hide()
	contract_offer.hide()
	player_profile.hide()


func _show_active_view(p_active_view: int = -1, from_history: bool = false) -> void:
	_hide_all()
	if p_active_view > -1:
		active_view = p_active_view

	match active_view:
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
		ContentViews.PLAYERS:
			player_list.show()
		ContentViews.INFO:
			info.show()
		ContentViews.PLAYER_OFFER:
			player_offer.show()
		ContentViews.PLAYER_PROFILE:
			player_profile.show()
		ContentViews.CONTRACT_OFFER:
			contract_offer.show()
		_:
			email.show()
	
	if not from_history:
		# overwrite history, if other view clicked, while in prevois view
		if view_history_index < view_history.size() - 1:
			view_history = view_history.slice(0, view_history_index + 1)
		
		# add to history
		if view_history.size() == 0 or active_view != view_history[-1]:
			view_history.append(active_view)
			if view_history.size() > 100:
				view_history.pop_front()
			# set history index to latest
			view_history_index = view_history.size() - 1



func _on_continue_pressed() -> void:
	_next_day()
	# remove comment to test player progress
	# PlayerProgress.update_players()


func _on_next_match_pressed() -> void:
	next_match_button.disabled = true
	continue_button.disabled = true
	
	while not match_ready:
		_next_day()
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.start(DASHBOARD_DAY_DELAY)
		await timer.timeout

	next_match_button.disabled = false
	continue_button.disabled = false


func _next_day() -> void:
	if match_ready:
		get_tree().change_scene_to_file("res://src/screens/match/match.tscn")
		return

	# next day in calendar
	for league: League in Config.leagues.list:
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
		_show_active_view(ContentViews.CONTRACT_OFFER)
	else:
		print("ERROR: Email action with no type. Text: " + message.text)


func _on_contract_offer_cancel() -> void:
	contract_offer.hide()
	_show_active_view(ContentViews.EMAIL)


func _on_contract_offer_confirm() -> void:
	contract_offer.hide()
	_show_active_view(ContentViews.EMAIL)


func _on_player_offer_confirm() -> void:
	email.update_messages()
	player_offer.hide()
	_show_active_view(ContentViews.ALL_PLAYERS)


func _on_player_offer_cancel() -> void:
	_show_active_view(ContentViews.ALL_PLAYERS)


func _on_prev_view_pressed() -> void:
	view_history_index -= 1
	if view_history_index < 1:
		view_history_index = 0
		# TODO emit other negative click sound
	
	active_view = view_history[view_history_index]
	_show_active_view(active_view, true)


func _on_next_view_pressed() -> void:
	view_history_index += 1
	if view_history_index > view_history.size() - 1:
		view_history_index = view_history.size() - 1
		# TODO emit other negative click sound
	
	active_view = view_history[view_history_index]
	_show_active_view(active_view, true)
