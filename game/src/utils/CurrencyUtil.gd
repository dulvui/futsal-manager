extends Node

enum Currencies {
	EURO,
	DOLLAR,
	POUND,
	BITCOIN
}

const SIGNS:Array = [
	"€",
	"$",
	"£",
	"₿"
]


func convert_to():
	pass
	
func get_sign():
	return SIGNS[DataSaver.currency]
