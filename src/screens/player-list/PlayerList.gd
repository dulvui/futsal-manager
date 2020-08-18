extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var players = Players.players
	for player in players:
		var hbox = HBoxContainer.new()
		var name = Label.new()
		name.text = player["name"]
		
		var birth_date = Label.new()
		birth_date.text = player["birt_date"]
		
		hbox.add_child(name)
		hbox.add_child(birth_date)
		$ItemList.add_child(hbox)
