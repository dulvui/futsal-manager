extends KinematicBody2D

export (String, "G", "D", "WL", "WR", "P") var pos = "G"

var current_destination

var ball_pos

var stats = {
	"goals" : 0,
	"shots" : 0,
	"shots_on_target" : 0,
	"passes" : 0,
	"passes_success" : 0,
	"dribblings" : 0,
	"dribblings_success" : 0,
	"tackling" : 0,
	"tackling_success" : 0,
	"meters_run" : 0,
}



var player
var surname = ""

onready var ball = get_parent().get_node("Ball")
var opponent_players

export var shirt_number = "1"
export var shirt_color = Color.red

var has_ball = false #probably detects when ball enters Ball detector

func _ready():
#	if get_parent()["name"] == "HomePlayers":
#		opponent_players = get_parent().get_parent().get_node("AwayPlayers")
#	else:
#		opponent_players = get_parent().get_parent().get_node("HomePlayers")
		
	ball_pos = $BallPosition.global_position
	print("ball_pos " + str(ball_pos))

func set_up(new_player, pos, color):
	player = new_player
	$Control/ShirtNumber.text = str(player["nr"])
	$Control/ColorRect.color = color
	current_destination = pos

func _physics_process(delta):
	if not has_ball:
		mark_nearest_player()
	look_at(ball.global_position)
	
	if current_destination:
		move(current_destination)


func update():
	pass

# special movements: cornerns, penlaties, free kicks, kick off, rimessa
func move(destination):
	var distance_to_player = global_position.distance_to(destination)
	if distance_to_player > 20:
#		print("goooo")
		var direction = (destination - global_position).normalized()
		#accelerate before
		move_and_slide(direction * player["fisical"]["pace"] * 50)
#		move_and_slide(direction * 200)
	ball_pos = $BallPosition.global_position
	
	

func pass_ball():
	#make calculations if pass is succesful,
	# the sned succes signal, else fail
	pass
	#TWEEN
	
# move to player or ball, whatever closer is.
func mark_nearest_player():
	var nearest_player_distance = 5000
	var nearest_player
#	for player in opponent_players.get_children():
#		if player["name"] != "G":
#			if global_position.distance_to(player.global_position) < nearest_player_distance:
#				nearest_player = player
#				nearest_player_distance = global_position.distance_to(player.global_position)
	#TWEEN
