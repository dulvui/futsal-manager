extends Control

signal select_player

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

func add_players():
	for player in DataSaver.team["players"]["subs"]:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$Container/ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		
func add_all_players():
	for player in Players.players:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$Container/ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		
		
func select_player(player):
	print("change in lst")
	emit_signal("select_player",[player])
		
