extends Control

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")


func _ready():
	
	Leagues.add_random_players()
	
	var teams = Leagues.serie_a["teams"]
	for team in teams:
		var team_button = Button.new()
		team_button.text = team["name"]
		team_button.connect("pressed",self,"team_selected",[team])
		$TeamList.add_child(team_button)
		
#		for player in team["players"]:
#			var player_profile = PlayerProfile.instance()
#			$TeamList.add_child(player_profile)
#			player_profile.set_up_info(player)

func team_selected(team):
	DataSaver.save_team(team)
	print("team saved")
	CalendarUtil.create_calendar()
	print("calendar created")
	MatchMaker.inizialize_matches()
	print("matches initialized")
	DataSaver.save_all_data()
	
	EmailUtil.message(null,EmailUtil.MESSAGE_TYPES.WELCOME_MANAGER)
	
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")
