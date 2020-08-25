extends Control


var d_has_ball = true



func random_pass():
	
	
	var players = $HomePlayers.get_children().duplicate(true)
	players.shuffle()
	$Ball.move_to(players.pop_back().get_node("BallPosition").global_position)
