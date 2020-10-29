extends Node

signal exits_field

var position = Vector2(600,300)
var old_position = Vector2(600,300)
var mass = 9.81 # ????
var velocity
var heading

var field_size = Vector2(1200,600)

# of type SimulatorGoal
var home_goal
var away_goal

func set_up(new_home_goal,new_away_goal):
	home_goal = new_home_goal
	away_goal = new_away_goal

func update():
	old_position = position
	
	if not check_bounds():
		velocity *= 0.98 # friction
		if velocity > 0.1:
			position += velocity
			heading = velocity.normalized()
			
			
func check_bounds():
	# TODO
	# check if hits post, then reflect direction
	
	# REALLY BAD CODE
	if field_size.x < position.x < 0 or field_size.y < position.y < 0:
		if position.x < 600:
			if home_goal.left_post.y < position.y < home_goal.right_post.y:
				emit_signal("home_goal")
				return true
		else:
			if away_goal.left_post.y < position.y < away_goal.right_post.y:
				emit_signal("away_goal")
				return true
		emit_signal("exits_field")
		return true
	return false
	
	

func add_nois_to_kick(direction, force):
	direction.normalized()
	
	velocity = (direction * force) / mass

# TODO could take enum instead of coordinates,
# like kickoff places automatically in center
func place_at(new_position):
	position = new_position
	
func time_cover_distance(start,end,force):
	pass
	
func future_position(time):
	pass
