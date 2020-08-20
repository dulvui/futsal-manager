extends Control

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var players = Players.players
	for player in players:
#		var hbox = HBoxContainer.new()
		
		var player_profile = PlayerProfile.instance()
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		
#		var name = Label.new()
#		name.text = player["name"]
#
#		var birth_date = Label.new()
#		birth_date.text = player["birt_date"]
#
#		hbox.add_child(name)
#		hbox.add_child(birth_date)
		
