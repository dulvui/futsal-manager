extends Node

signal transfer_mail

var current_transfers = []

var transfers_active = true

func _ready():
	current_transfers = DataSaver.current_transfers
	

func update_day():
	
	#check with calendar if treansfer market is open, then send start/stop mail
	
	if transfers_active:
		for transfer in current_transfers:
			transfer["days"] -= 1
			if transfer["days"] < 1:
				transfer["success"] = randi()%2 == 0
				if transfer["success"]:
					DataSaver.make_transfer(transfer)
				emit_signal("transfer_mail",[transfer,"TRANSFER"])
				current_transfers.erase(transfer)
					
		_make_random_transfer_requests()

func make_offer(player,money):
	var transfer = {
		"player" : player,
		"money" : money,
		"days" : (randi()%5)+1
	}
	emit_signal("transfer_mail",[transfer,"TRANSFER"])
	print("transfer message")
	current_transfers.append(transfer)
	
# tells you if the club has intention to give the player away
func request_info():
	pass
	
	
# ai for transfer market that makes transfers for other teams
func _make_random_transfer_requests():
	pass
