extends Control

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

func add_players(players):
	for player in players:
		var player_profile = PlayerProfile.instance()
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		
