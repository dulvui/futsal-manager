extends Control


var d_has_ball = true

func set_numbers(home_team,away_team):
	print(str(home_team["G"]["nr"]))
	$HomePlayers/G/Control/ShirtNumber.text = str(home_team["G"]["nr"])
	$HomePlayers/D/Control/ShirtNumber.text = str(home_team["D"]["nr"])
	$HomePlayers/WR/Control/ShirtNumber.text = str(home_team["WR"]["nr"])
	$HomePlayers/WL/Control/ShirtNumber.text = str(home_team["WL"]["nr"])
	$HomePlayers/P/Control/ShirtNumber.text = str(home_team["P"]["nr"])
	$AwayPlayers/G/Control/ShirtNumber.text = str(away_team["G"]["nr"])
	$AwayPlayers/D/Control/ShirtNumber.text = str(away_team["D"]["nr"])
	$AwayPlayers/WR/Control/ShirtNumber.text = str(away_team["WR"]["nr"])
	$AwayPlayers/WL/Control/ShirtNumber.text = str(away_team["WL"]["nr"])
	$AwayPlayers/P/Control/ShirtNumber.text = str(away_team["P"]["nr"])

func random_pass():
	var players = $HomePlayers.get_children().duplicate(true)
	players.shuffle()
	$Ball.move_to(players.pop_back().get_node("BallPosition").global_position)

#func home_pass_to(position):
#	$Ball.move_to(players.pop_back().get_node("BallPosition").global_position)
