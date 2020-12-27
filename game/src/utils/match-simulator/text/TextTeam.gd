extends Node

const Player = preload("res://src/utils/match-simulator/text/TextPlayer.gd")

var goal_keeper
var field_players = []

enum states {ATTACK, DEFEND, HOME, CORNER, FREE_KICK}
var current_state = states.HOME

var player_with_ball

func set_up(team):
	goal_keeper = team["players"]["active"][0]
	for i in range(1,team["players"]["active"].size()):
		field_players.append(team["players"]["active"][i])
	
func update():
# CREATE STATE MACHINE FOR TEAM
#
#	match current_state:
#
	pass
