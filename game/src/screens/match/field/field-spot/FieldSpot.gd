extends Position2D


func _ready():
	var home_goal_spot = get_parent().get_parent().get_node("HomeGoal").center_spot
	var away_goal_spot = get_parent().get_parent().get_node("AwayGoal").center_spot
	$HomeGoalRayCast.cast_to = home_goal_spot - $HomeGoalRayCast.global_position
	$AwayGoalRayCast.cast_to = away_goal_spot - $AwayGoalRayCast.global_position
	

func get_home_goal_value():
	if check_away_ray_cast():
		#check distance to goal by looking to cast to vector and return value
		return (randi()%5)+5
	else:
		return randi()%5
	
	
func get_away_goal_value(player):
	pass
	
func distance_to_player(player):
	# calc distance to player
	pass
	
func check_home_ray_cast():
	if $HomeGoalRayCast.get_collider() == null:
		return true
	return false
	
func check_away_ray_cast():
	if $AwayGoalRayCast.get_collider() == null:
		return true
	return false
	
