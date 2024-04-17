extends Node2D
class_name VisualGoalKeeper

@onready var body:Sprite2D = $Sprites/Body

var sim_goal_player:SimGoalkeeper
var sim_ball:SimBall

func _process(delta: float) -> void:
	global_position = global_position.lerp(sim_goal_player.pos, delta * Config.speed_factor * Constants.ticks_per_second)
	look_at(sim_ball.global_position)

func set_up(p_sim_goal_player:SimGoalkeeper, p_sim_ball:SimBall) -> void:
	sim_goal_player = p_sim_goal_player
	sim_ball = p_sim_ball
	global_position = sim_goal_player.pos
	
func set_color(p_color:Color) -> void:
	body.modulate = p_color

