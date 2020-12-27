extends Node2D

var center

func _ready():
	center = $Center.global_position

func _on_GoalDetector_body_entered(body):
	pass # Replace with function body.
