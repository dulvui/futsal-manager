extends Area2D

export (String, "G", "D", "WL", "WR", "P") var pos = "G"

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
var surname = ""

onready var ball = get_parent().get_parent().get_node("Ball")
var opponent_players

export var shirt_number = "1"
export var shirt_color = Color.red

var has_ball = false #probably detects when ball enters Ball detector

func _ready():
	$Control/ShirtNumber.text = shirt_number
	$Control/ColorRect.color = shirt_color
	
	if get_parent()["name"] == "HomePlayers":
		opponent_players = get_parent().get_parent().get_node("AwayPlayers")
	else:
		opponent_players = get_parent().get_parent().get_node("HomePlayers")

func set_up(player):
	pass

func _physics_process(delta):
	if not has_ball:
		mark_nearest_player()
	look_at(ball.global_position)


func update():
	pass

# move to player or ball, whatever closer is.
# special movements: cornerns, penlaties, free kicks, kick off, rimessa
func move(destination):
	var direction = (destination.global_position - global_position).normalized()
	var distance_to_player = global_position.distance_to(destination.global_position)
	#TWEEN
	

func pass_ball():
	pass
	#TWEEN
	
func mark_nearest_player():
	var nearest_player_distance = 5000
	var nearest_player
	for player in opponent_players.get_children():
		if player["name"] != "G":
			if global_position.distance_to(player.global_position) < nearest_player_distance:
				nearest_player = player
				nearest_player_distance = global_position.distance_to(player.global_position)
	#TWEEN
