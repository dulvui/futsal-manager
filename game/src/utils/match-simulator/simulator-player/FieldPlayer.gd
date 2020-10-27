extends Node


const SimulatorPlayer = preload("res://src/utils/match-simulator/simulator-player/SimulatorPlayer.gd")

enum states {CHASE,KICK,WAIT,HOME,SUPPORT} 
enum roles {DC,DL,DR,CL,CR,CC,AL,AR,AC} 


var state
var role

var home_region # gets assigned depending on role and formation + tactics
var kick_off_region # kick in, corner etc??

var dinstance_to_ball
var steering

var has_ball # is function is_controlling player in simple soccer

func is_ahead_of_attacker():
	pass
	
func at_target():
	pass
	
func at_support_spot():
	pass
	
# could be moved to team code
func is_closest_to_ball():
	pass
	
func in_hot_region():
	pass
