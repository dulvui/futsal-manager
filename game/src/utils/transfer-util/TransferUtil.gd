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
			if "PENDING" in transfer["state"]:
				transfer["days"] -= 1
				if transfer["days"] < 1:
					if transfer["state"] == "TEAM_PENDING":
#						transfer["success"] = randi()%2 == 0
						transfer["success"] = true
		#				if transfer["success"]:
		#					DataSaver.make_transfer(transfer)
						emit_signal("transfer_mail",[transfer,"CONTRACT_OFFER"])
		#				current_transfers.erase(transfer)
						transfer["days"] = (randi()%5)+1
						transfer["state"] = "MAKE_CONTRACT_OFFER"
					elif transfer["state"] == "CONTRACT_PENDING":
						transfer["success"] = randi()%2 == 0
		#				if transfer["success"]:
						transfer["state"] = "SUCCESS"
						DataSaver.make_transfer(transfer)
						emit_signal("transfer_mail",[transfer,"CONTRACT_SIGNED"])
		#				current_transfers.erase(transfer)
						
					
		_make_random_transfer_requests()

func make_offer(transfer):
	emit_signal("transfer_mail",[transfer,"TRANSFER"])
	print("transfer message")
	current_transfers.append(transfer)
	
# tells you if the club has intention to give the player away
func request_info():
	pass
	
	
# ai for transfer market that makes transfers for other teams
func _make_random_transfer_requests():
	pass
