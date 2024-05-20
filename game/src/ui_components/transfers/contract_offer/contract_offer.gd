# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

signal cancel
signal confirm

const MAX_BUY_CLAUSE: int = 999999999

@onready var income_label: Label = $VBoxContainer/GridContainer/Income
@onready var info_label: Label = $VBoxContainer/Info
@onready var years_label: Label = $VBoxContainer/GridContainer/Years
@onready var buy_clause_label: Label = $VBoxContainer/GridContainer/BuyClause

var income: int = 0
var years: int = 1
var buy_clause: int = 0

var team: Team
var player: Player
var transfer:Transfer


func _ready() -> void:
	team = Config.team
	
func set_up(p_transfer:Transfer) -> void:
	transfer = p_transfer
	player = transfer.player
	
	info_label.text = "Offer a contract to " + player.get_full_name()

func _on_IncomeMore_pressed() -> void:
	if income  < team.salary_budget:
		income += 1000
	income_label.text = str(income)

func _on_IncomeLess_pressed() -> void:
	if income > 1000:
		income -= 1000
		income_label.text = str(income)


func _on_YearsLess_pressed() -> void:
	if years > 1:
		years -= 1
		years_label.text = str(years)


func _on_YearsMore_pressed() -> void:
	if years < 4:
		years += 1
		years_label.text = str(years)


func _on_BuyClauseLess_pressed() -> void:
	if buy_clause > 1000:
		buy_clause -= 1000
		buy_clause_label.text = str(buy_clause)


func _on_BuyClauseMore_pressed() -> void:
	if buy_clause < MAX_BUY_CLAUSE:
		buy_clause += 1000
		buy_clause_label.text = str(buy_clause)


func _on_Confirm_pressed() -> void:
	# add contract to pendng contracts 

	var contract:Contract = Contract.new()
	contract.buy_clause = buy_clause
	contract.income = income

	transfer.contract = contract
	transfer.state = Transfer.State.CONTRACT_PENDING
	EmailUtil.transfer_message(transfer)
	emit_signal("confirm")


func _on_Cancel_pressed() -> void:
	emit_signal("cancel")


