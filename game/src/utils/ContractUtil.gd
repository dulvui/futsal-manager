extends Node

var def_contract = {
	"player" : {},
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
	"days" : (randi()%5)+1,
	"is_on_loan" : false # if player is on loan, the other squad gets copy of contract with percentage of income
}
