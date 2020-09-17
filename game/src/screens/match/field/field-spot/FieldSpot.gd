extends Position2D

var distance_to_goal

func _ready():
#	var goal_spot
#	if get_parent().name == "HomeFieldSpots":
#		goal_spot = get_parent().get_parent().get_node("HomeGoal").center_spot
#	else:
#
#		goal_spot = get_parent().get_parent().get_node("AwayGoal").center_spot
#	look_at(goal_spot)
	var home_goal_spot = get_parent().get_parent().get_node("HomeGoal").center_spot
	var away_goal_spot = get_parent().get_parent().get_node("AwayGoal").center_spot
	$HomeGoalRayCast.cast_to = home_goal_spot - $HomeGoalRayCast.global_position
	$AwayGoalRayCast.cast_to = away_goal_spot - $AwayGoalRayCast.global_position


func get_bpp_value(player):
	pass
	
func distance_to_player(player):
	# calc distance to player
	pass
	
func check_player_ray_cast():
	# check if goal can be scored or player intercepts
	pass
	
func check_goal_ray_cast():
	# check if goal can be scored or player intercepts
	pass
	
