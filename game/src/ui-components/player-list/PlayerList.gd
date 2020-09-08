extends Control

signal select_player

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")

func add_players():
	var g = DataSaver.team["players"]["G"]
	var player_profile_g = PlayerProfile.instance()
	player_profile_g.connect("player_select",self,"select_player",[g])
	player_profile_g.set_up_info(g)
	$ItemList.add_child(player_profile_g)
	

	var d = DataSaver.team["players"]["D"]
	var player_profile_d = PlayerProfile.instance()
	player_profile_d.connect("player_select",self,"select_player",[d])
	player_profile_d.set_up_info(d)
	$ItemList.add_child(player_profile_d)
	
	var wl = DataSaver.team["players"]["WL"]
	var player_profile_wl = PlayerProfile.instance()
	player_profile_wl.connect("player_select",self,"select_player",[wl])
	player_profile_wl.set_up_info(wl)
	$ItemList.add_child(player_profile_wl)

	var wr = DataSaver.team["players"]["WR"]
	var player_profile_wr = PlayerProfile.instance()
	player_profile_wr.connect("player_select",self,"select_player",[wr])
	player_profile_wr.set_up_info(wr)
	$ItemList.add_child(player_profile_wr)
	
	var p = DataSaver.team["players"]["P"]
	var player_profile_p = PlayerProfile.instance()
	player_profile_p.connect("player_select",self,"select_player",[p])
	player_profile_p.set_up_info(p)
	$ItemList.add_child(player_profile_p)
	
	for player in DataSaver.team["players"]["subs"]:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		
func add_match_players():
	var g = DataSaver.team["players"]["G"]
	var player_profile_g = PlayerProfile.instance()
	player_profile_g.connect("player_select",self,"select_player",[g])
	player_profile_g.set_up_info(g)
	$ItemList.add_child(player_profile_g)
	

	var d = DataSaver.team["players"]["D"]
	var player_profile_d = PlayerProfile.instance()
	player_profile_d.connect("player_select",self,"select_player",[d])
	player_profile_d.set_up_info(d)
	$ItemList.add_child(player_profile_d)
	
	var wl = DataSaver.team["players"]["WL"]
	var player_profile_wl = PlayerProfile.instance()
	player_profile_wl.connect("player_select",self,"select_player",[wl])
	player_profile_wl.set_up_info(wl)
	$ItemList.add_child(player_profile_wl)

	var wr = DataSaver.team["players"]["WR"]
	var player_profile_wr = PlayerProfile.instance()
	player_profile_wr.connect("player_select",self,"select_player",[wr])
	player_profile_wr.set_up_info(wr)
	$ItemList.add_child(player_profile_wr)
	
	var p = DataSaver.team["players"]["P"]
	var player_profile_p = PlayerProfile.instance()
	player_profile_p.connect("player_select",self,"select_player",[p])
	player_profile_p.set_up_info(p)
	$ItemList.add_child(player_profile_p)
	
	for player in DataSaver.team["players"]["subs"].slice(0,9):
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
	
		
func add_all_players():
	var i = 0
	for player in Players.players:
		var player_profile = PlayerProfile.instance()
		player_profile.connect("player_select",self,"select_player",[player])
		$ItemList.add_child(player_profile)
		player_profile.set_up_info(player)
		i+=1
		
func select_player(player):
	print("change in lst")
	emit_signal("select_player",player)
		
