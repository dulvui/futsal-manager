extends Node2D

signal goal

var center_spot


func _ready():
	center_spot = $ShootSpotCenter.global_position


func _on_GoalDetector_body_entered(body):
	emit_signal("goal")
