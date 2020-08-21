extends Control

onready var animation_player = $AnimationPlayer

var formations = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1"]
var offensive_tactics = ["POSESSION","FAST","WINGS"]
var defensive_tactics = ["STAY_HIGH","STAY_LOW","PRESSING"]

var current_formation = "2-2"


# Called when the node enters the scene tree for the first time.
func _ready():
	for formation in formations:
		$FormationSelect.add_item(formation)
		
	for tactic in offensive_tactics:
		$OffensiceTactics.add_item(tactic)
		
	for tactic in defensive_tactics:
		$DefensiveTactics.add_item(tactic)
		
	_set_players()
		
	animation_player.play("Fade" + current_formation)

func _on_FormationSelect_item_selected(index):
	animation_player.play_backwards("Fade" + current_formation)
	yield(animation_player,"animation_finished")
	_set_players()
	current_formation = formations[index]
	animation_player.play("Fade" + current_formation)
	

func _set_players():
	$Field/G.set_player(DataSaver.team["players"][0])
	$Field/D.set_player(DataSaver.team["players"][4])
	$Field/WL.set_player(DataSaver.team["players"][7])
	$Field/WR.set_player(DataSaver.team["players"][9])
	$Field/P.set_player(DataSaver.team["players"][12])
