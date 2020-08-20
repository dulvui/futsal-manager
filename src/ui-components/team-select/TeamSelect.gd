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
	MatchMaker.inizialize_matches()
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")
