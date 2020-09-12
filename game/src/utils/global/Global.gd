extends Node2D


func _ready():
	TransferUtil.connect("transfer_mail",EmailUtil,"message")
	
