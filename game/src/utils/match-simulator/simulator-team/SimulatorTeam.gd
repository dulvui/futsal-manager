extends Node

const Player = preload("res://src/utils/match-simulator/simulator-player/SimulatorPlayer.gd")


enum states {
	DEFENDING,ATTACKING,KICKOFF,
	CORNER,KICKIN,FREEKICK,PENALTY,
	SIXFOUL,ENTER_FIELD,EXIT_FIELD,
	SUBSTITUTION,INJURY,RED_CARD # might move some to players like red card
}

var state

var players = []

var player_control
var player_receive
var player_support
var player_closest_to_ball

var distance_player_closest_to_ball

# Called when the node enters the scene tree for the first time.
func update_wait_players():
	pass

# checks if player_control is in hot zone or has free sight to goal
func can_shot():
	pass


# checks if a player is in range and has free sight
func can_pass():
	pass
	
func is_pass_safe():
	pass
	
func find_pass(): # finds the player who to pass
	pass

# checks if pass direclty to players or on border of bounding circle
func get_best_pass_destination():
	pass
	
func is_opponent_within_radius():
	pass
	
func request_pass():
	pass
	
func count_players_at_home():
	pass

