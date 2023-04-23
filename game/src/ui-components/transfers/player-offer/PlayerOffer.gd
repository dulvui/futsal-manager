extends Control

signal confirm

var team
var player

var regex = RegEx.new()
var oldtext = ""

var total = 0
var amount = 0

var exchange_players = []
var selected_players = []

func _ready() -> void:
	regex.compile("^[0-9]*$")
	$Details/Types.add_item("TRANSFER")
	$Details/Types.add_item("LOAN")
	
	$Details/Money/Amount.text = str(amount)
	
	team = DataSaver.get_selected_team()
	for active_player in team["players"]["active"]:
		$Details/ExchangePlayers.add_item(active_player["name"] + " " + str(active_player["price"]/1000) + "K")
		exchange_players.append(active_player)
		
	for sub_player in team["players"]["subs"]:
		$Details/ExchangePlayers.add_item(sub_player["name"] + " " + str(sub_player["price"]/1000) + "K")
		exchange_players.append(sub_player)

func _process(_delta) -> void:
	$Total.text = str(total)

func set_player(new_player) -> void:
	player = new_player
	$Info.text = "The player " + player["name"] + " has a value of " + str(player["price"])


func _on_More_pressed() -> void:
	if  amount < team["budget"]:
		amount += 1000
		$Details/Money/Amount.text = str(amount)
		
	_calc_total()

func _on_Less_pressed() -> void:
	if  amount > 0:
		amount -= 1000
		$Details/Money/Amount.text = str(amount)
		
	_calc_total()


func _on_ExchangePlayers_item_selected(index) -> void:
	var exchange_player = exchange_players[index]
	exchange_players.remove(index)
	
	selected_players.append(player)

	var remove_button = Button.new()
	remove_button.text = exchange_player["name"] + " " + str(exchange_player["price"]/1000) + "K"
	remove_button.pressed.connect(remove_from_list.bind(exchange_player))
	$ScrollContainer/SelectedPlayers.add_child(remove_button)
	
	$Details/ExchangePlayers.remove_item(index)
	
	_calc_total()
	
func remove_from_list(player) -> void:
	for child in $ScrollContainer/SelectedPlayers.get_children():
		child.queue_free()
	selected_players.erase(player)
	exchange_players.append(player)
	
	# might be broken after Godot 4 upgrade, check _player and selected player
	# before only _player existed
	for selected_player in selected_players:
		var remove_button = Button.new()
		remove_button.text = selected_player["name"] + " " + str(selected_player["price"]/1000) + "K"
		remove_button.pressed.connect(remove_from_list.bind(selected_player))
		$ScrollContainer/SelectedPlayers.add_child(remove_button)
	
	$Details/ExchangePlayers.add_item(player["name"])
	_calc_total()
	
func _calc_total() -> void:
	total = amount
	for selected_player in selected_players:
		total += selected_player["price"] # use other calculated value be setimating importanc efor new tweam
	


func _on_Amount_text_changed(new_text) -> void:
	if regex.search(new_text):
		$Details/Money/Amount.text = new_text   
		oldtext = $Details/Money/Amount.text
	else:
		$Details/Money/Amount.text = oldtext
	
	amount = int($Details/Money/Amount.text)
	if amount > team["budget"]:
		amount = team["budget"]
		$Details/Money/Amount.text = str(amount)
		
	_calc_total()
	$Details/Money/Amount.set_cursor_position($Details/Money/Amount.text.length())


func _on_Confirm_pressed() -> void:
	var transfer = {
		"player" : player,
		"money" : amount,
		"exchange_players" : selected_players,
		"days" : (randi()%5)+1,
		"contract" : {},
		"state" : "TEAM_PENDING" #0 is offer, 1 is contract pending, 2 is contract result
	}
	TransferUtil.make_offer(transfer)
	emit_signal("confirm")


func _on_Cancel_pressed() -> void:
	hide()
