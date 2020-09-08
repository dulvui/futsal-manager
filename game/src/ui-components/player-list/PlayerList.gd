extends Control

signal select_player

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

func add_players():
	for child in $ItemList.get_children():
		child.queue_free()
		
	var team = DataSaver.get_selected_team()
	for player in team["players"]["active"]:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
	
	for player in team["players"]["subs"]:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		
func add_match_players():
	var team = DataSaver.get_selected_team()
	for player in team["players"]["active"]:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
	
	for player in team["players"]["subs"].slice(0,9):
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
	
		
func add_all_players():
	for child in $ItemList.get_children():
		child.queue_free()
	for team in DataSaver.teams:
		if team["name"] != DataSaver.selected_team:
			for player in team["players"]["subs"]:
				var player_profile = PlayerProfile.instance()
				player_profile.connect("player_select",self,"select_player",[player])
				player_profile.set_up_info(player)
				$ItemList.add_child(player_profile)
				
			for player in team["players"]["active"]:
				var player_profile = PlayerProfile.instance()
				player_profile.connect("player_select",self,"select_player",[player])
				player_profile.set_up_info(player)
				$ItemList.add_child(player_profile)
			
			
func select_player(player):
	print("change in lst")
	emit_signal("select_player",player)
		
