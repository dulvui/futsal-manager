extends Node

var current_contract_offers = []

var def_contract = {
	"price" : 0,
	"money/week" : 0,
	"start_date" : "01/01/2020",
	"end_date" : "01/01/2021",
	"bonus" : {
		"goal" : 0,
		"clean_sheet" : 0,
		"assist" : 0,
		"league_title" : 0,
		"nat_cup_title" : 0,
		"inter_cup_title" : 0,
	},
	"buy_clause" : 0,
	"is_on_loan" : false # if player is on loan, the other squad gets copy of contract with percentage of income
}


func _ready():
	current_contract_offers = DataSaver.current_contract_offers

func make_contract_offer(player,contract):
	pass
