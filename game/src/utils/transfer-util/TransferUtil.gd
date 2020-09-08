extends Node

signal transfer_mail

var current_transfers = []

var transfers_active = false

func _ready():
	current_transfers = DataSaver.current_transfers
	

func update_day():
	
	#check with calendar if treansfer market is open, then send start/stop mail
	
	if transfers_active:
		for transfer in current_transfers:
			transfer["days"] -= 1
			if transfer["days"] < 1:
				emit_signal("transfer_mail",[transfer,"TRANSFER"])
				
		_make_random_transfer_requests()

func make_offer(player,current_team,new_team,money):
	var transfer = {
		"player" : player,
		"current_team" : current_team,
		"new_team" : new_team,
		"money" : money
	}
	emit_signal("transfer_mail",[transfer,"TRANSFER"])
	print("transfer messgae ")
	current_transfers.append(transfer)
	
# tells you if the club has intention to give the player away
func request_info():
	pass
	
	
# ai for transfer market that makes transfers for other teams
func _make_random_transfer_requests():
	pass
