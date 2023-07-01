extends Node

signal transfer_mail

var current_transfers = []

var transfers_active = true

func _ready() -> void:
	current_transfers = DataSaver.current_transfers


func update_day() -> void:
	#check with calendar if treansfer market is open, then send start/stop mail
	if transfers_active:
		for transfer in current_transfers:
			if "PENDING" in transfer["state"]:
				transfer["days"] -= 1
				if transfer["days"] < 1:
					if transfer["state"] == "TEAM_PENDING":
#						transfer["success"] = randi()%2 == 0
						transfer["success"] = true
						transfer["days"] = (randi()%5)+1
						transfer["state"] = "MAKE_CONTRACT_OFFER"
						EmailUtil.new_message(EmailUtil.MessageTypes.CONTRACT_OFFER, transfer)
					elif transfer["state"] == "CONTRACT_PENDING":
						transfer["success"] = randi()%2 == 0
		#				if transfer["success"]:
						transfer["state"] = "SUCCESS"
						DataSaver.make_transfer(transfer)
						EmailUtil.new_message(EmailUtil.MessageTypes.CONTRACT_SIGNED, transfer)
		_make_random_transfer_requests()

func make_offer(transfer:Dictionary) -> void:
	EmailUtil.new_message(EmailUtil.MessageTypes.TRANSFER, transfer)
	print("transfer message")
	current_transfers.append(transfer)
	
# tells you if the club has intention to give the player away
func request_info() -> void:
	pass
	
	
# ai for transfer market that makes transfers for other teams
func _make_random_transfer_requests() -> void:
	pass
