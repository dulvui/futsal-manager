extends Control


var d_has_ball = true

func set_numbers(home_team,away_team):
	for player in home_team:
		print(player["nr"])
	print("set numer")
	$HomePlayers/G/Control/ShirtNumber.text = str(home_team[0]["nr"])
	$HomePlayers/D/Control/ShirtNumber.text = str(home_team[1]["nr"])
	$HomePlayers/WR/Control/ShirtNumber.text = str(home_team[2]["nr"])
	$HomePlayers/WL/Control/ShirtNumber.text = str(home_team[3]["nr"])
	$HomePlayers/P/Control/ShirtNumber.text = str(home_team[4]["nr"])
	$AwayPlayers/G/Control/ShirtNumber.text = str(away_team[0]["nr"])
	$AwayPlayers/D/Control/ShirtNumber.text = str(away_team[1]["nr"])
	$AwayPlayers/WR/Control/ShirtNumber.text = str(away_team[2]["nr"])
	$AwayPlayers/WL/Control/ShirtNumber.text = str(away_team[3]["nr"])
	$AwayPlayers/P/Control/ShirtNumber.text = str(away_team[4]["nr"])

func random_pass():
	var players = $HomePlayers.get_children().duplicate(true)
	players.shuffle()
	$Ball.move_to(players.pop_back().get_node("BallPosition").global_position)

#func home_pass_to(position):
#	$Ball.move_to(players.pop_back().get_node("BallPosition").global_position)
