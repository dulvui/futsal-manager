extends Node2D

signal goal


func _ready():
	pass # Replace with function body.


func _on_GoalDetector_body_entered(body):
	emit_signal("goal")
