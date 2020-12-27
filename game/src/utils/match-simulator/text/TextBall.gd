extends Node

var position
var field

# TODO check if ball is really needed, since it could be obmitted
# by simply what player has ball
# ball position is simply current players with ball pos

func set_up(field_size):
	field = field_size
	kick_off()
	
func kick_off():
	position = field / 2
