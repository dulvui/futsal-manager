extends Control

var team

var regex = RegEx.new()
var oldtext = ""

var total = 0
var amount = 0

var exchange_players = []
var selected_players = []

func _ready():
	regex.compile("^[0-9]*$")
	$Details/Types.add_item("TRANSFER")
	$Details/Types.add_item("LOAN")
	
	$Details/Money/Amount.text = str(amount)
	
	team = DataSaver.get_selected_team()
	for player in team["players"]["active"]:
		$Details/ExchangePlayers.add_item(player["name"] + " " + str(player["price"]/1000) + "K")
		exchange_players.append(player)
		
	for player in team["players"]["subs"]:
		$Details/ExchangePlayers.add_item(player["name"] + " " + str(player["price"]/1000) + "K")
		exchange_players.append(player)

func _process(delta):
	$Total.text = str(total)

func set_player(player):
	$Info.text = "The player " + player["name"] + " has a value of " + player["contract"]["price"]


func _on_More_pressed():
	if  amount < team["budget"]:
		amount += 1000
		$Details/Money/Amount.text = str(amount)
		
	_calc_total()

func _on_Less_pressed():
	if  amount > 0:
		amount -= 1000
		$Details/Money/Amount.text = str(amount)
		
	_calc_total()


func _on_ExchangePlayers_item_selected(index):
	var player = exchange_players[index]
	exchange_players.remove(index)
	
	selected_players.append(player)

	var remove_button = Button.new()
	remove_button.text = player["name"] + " " + str(player["price"]/1000) + "K"
	remove_button.connect("pressed",self,"remove_from_list",[player])
	$ScrollContainer/SelectedPlayers.add_child(remove_button)
	
	$Details/ExchangePlayers.remove_item(index)
	
	_calc_total()
	
func remove_from_list(player):
	for child in $ScrollContainer/SelectedPlayers.get_children():
		child.queue_free()
	selected_players.erase(player)
	exchange_players.append(player)
	
	for player in selected_players:
		var remove_button = Button.new()
		remove_button.text = player["name"] + " " + str(player["price"]/1000) + "K"
		remove_button.connect("pressed",self,"remove_from_list",[player])
		$ScrollContainer/SelectedPlayers.add_child(remove_button)
	
	$Details/ExchangePlayers.add_item(player["name"])
	_calc_total()
	
func _calc_total():
	total = amount
	for player in selected_players:
		total += player["price"] # use other calculated value be setimating importanc efor new tweam
	


func _on_Amount_text_changed(new_text):
	if regex.search(new_text):
		$Details/Money/Amount.text = new_text   
		oldtext = $Details/Money/Amount.text
	else:
		$Details/Money/Amount.text = oldtext
	amount = int($Details/Money/Amount.text)
	_calc_total()
	$Details/Money/Amount.set_cursor_position($Details/Money/Amount.text.length())
