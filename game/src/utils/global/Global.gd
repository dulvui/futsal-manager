extends Node2D


func _ready():
	TransferUtil.connect("transfer_mail",EmailUtil,"message")
	TransferUtil.connect("transfer_mail",self,"test")
	
func test(message):
	print(message)
