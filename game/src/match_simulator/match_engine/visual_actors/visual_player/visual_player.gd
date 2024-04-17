extends Node2D
class_name VisualPlayer

@onready var body:Sprite2D = $Sprites/Body

var sim_player:SimPlayer
var sim_ball:SimBall

func _process(delta: float) -> void:
	global_position = global_position.lerp(sim_player.pos, delta * Config.speed_factor * Constants.ticks_per_second)
	look_at(sim_ball.global_position)

func set_up(p_sim_player:SimPlayer, p_sim_ball:SimBall) -> void:
	sim_player = p_sim_player
	sim_ball = p_sim_ball
	global_position = sim_player.pos
	
func set_color(p_color:Color) -> void:
	body.modulate = p_color
