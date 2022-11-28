extends KinematicBody2D

const SPEED_FACTOR = 600

var speed = Vector2(0,0)
var destination
var distance

func follow_ball(ball_position):
	destination = (ball_position - position).normalized()
	distance = position.distance_squared_to(destination)
	destination.y = 0
	move_and_slide(speed * distance * destination * SPEED_FACTOR)

