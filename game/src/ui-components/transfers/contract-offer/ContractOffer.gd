extends Control

signal cancel
signal confirm

var income = 0
var years = 1
var buy_clause = 0

var team
var player
var transfer


func _ready():
	team = DataSaver.get_selected_team()
	
func set_up(new_transfer):
	transfer = new_transfer
	player = new_transfer["player"]
	
	$Info.text = "The player " + player["name"] + " " +  player["surname"] + " had a contract..."

func _on_IncomeMore_pressed():
#	if income < team["salary_budget"]:
	income += 1000
	$GridContainer/Income.text = str(income)

func _on_IncomeLess_pressed():
	if income > 1000:
		income -= 1000
		$GridContainer/Income.text = str(income)


func _on_YearsLess_pressed():
	if years > 1:
		years -= 1
		$GridContainer/Years.text = str(years)


func _on_YearsMore_pressed():
	if years < 4:
		years += 1
		$GridContainer/Years.text = str(years)


func _on_BuyClauseLess_pressed():
	if buy_clause > 1000:
		buy_clause -= 1000
		$GridContainer/BuyClause.text = str(buy_clause)


func _on_BuyClauseMore_pressed():
	if buy_clause < 999999999:
		buy_clause += 1000
		$GridContainer/BuyClause.text = str(buy_clause)


func _on_Confirm_pressed():
	# add contract to pendng contracts 
	
	var def_contract = {
		"player" : player,
		"price" : 0,
		"money/week" : income,
		"start_date" : "01/01/2020", #today
		"end_date" : "01/01/2021", #next season end in x years
		"bonus" : {
			"goal" : 0,
			"clean_sheet" : 0,
			"assist" : 0,
			"league_title" : 0,
			"nat_cup_title" : 0,
			"inter_cup_title" : 0,
		},
		"buy_clause" : buy_clause,
		"days" : (randi()%5)+1,
		#different ui for loan and noarmal contract
		#send loan contracts with other signal or type
		"is_on_loan" : false # if player is on loan, the other squad gets copy of contract with percentage of income
	}
	for transferz in TransferUtil.current_transfers:
		if transfer == transferz:
			transferz["contract"] = def_contract
			transferz["days"] = 3
			transferz["state"] = "CONTRACT_PENDING"
			print("CAZOOOOOOOO")
			EmailUtil.message([transfer,"CONTRACT_OFFER_MADE"])
	emit_signal("confirm")
#	ContractUtil.current_contract_offers.append(def_contract)


func _on_Cancel_pressed():
	emit_signal("cancel")


