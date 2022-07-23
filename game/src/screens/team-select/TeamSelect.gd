extends TabContainer

const PlayerProfile = preload("res://src/ui-components/player-profile/PlayerProfile.tscn")


func _ready():
	
	Leagues.init_teams()
	
	for nation in Leagues.leagues:
		for league in Leagues.leagues[nation]:
			for teams in  Leagues.leagues[nation][league].keys():
				var center_container = CenterContainer.new()
				center_container.name = league
				var grid = GridContainer.new()
				grid.columns = 2
				for team in Leagues.leagues[nation][league][teams]:
					var team_button = Button.new()
					team_button.text = team["name"]
					team_button.connect("pressed",self,"team_selected",[Leagues.leagues[nation][league][teams],team])
					grid.add_child(team_button)
				center_container.add_child(grid)
				add_child(center_container)

func team_selected(teams, selected_team):
	DataSaver.select_team(teams,selected_team)
	print("team saved")
	CalendarUtil.create_calendar()
	print("calendar created")
	MatchMaker.inizialize_matches()
	print("matches initialized")
	
	EmailUtil.message(null,EmailUtil.MESSAGE_TYPES.WELCOME_MANAGER)
	
	DataSaver.save_all_data()
	get_tree().change_scene("res://src/screens/dashboard/Dashboard.tscn")
