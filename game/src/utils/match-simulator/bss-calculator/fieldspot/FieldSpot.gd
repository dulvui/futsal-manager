extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func set_up(goal):
	$GoalRayCast.cast_to = goal.center - $GoalRayCast.global_position
#	$AwayGoalRayCast.cast_to = away_goal_spot - $AwayGoalRayCast.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
