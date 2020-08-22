extends Control

onready var animation_player = $AnimationPlayer

var formations = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1"]
var offensive_tactics = ["POSESSION","FAST","WINGS"]
var defensive_tactics = ["STAY_HIGH","STAY_LOW","PRESSING"]

var player_to_replace


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	for formation in formations:
		$FormationSelect.add_item(formation)
		
	$FormationSelect.selected = formations.find(DataSaver.selected_formation)
		
	for tactic in offensive_tactics:
		$OffensiceTactics.add_item(tactic)
		
	for tactic in defensive_tactics:
		$DefensiveTactics.add_item(tactic)
		
	$PlayerSelect/PlayerList.add_players(DataSaver.selected_players)
		
	
	
	_set_players()
		
	animation_player.play("Fade" + DataSaver.selected_formation)

func _on_FormationSelect_item_selected(index):
	animation_player.play_backwards("Fade" + DataSaver.selected_formation)
	yield(animation_player,"animation_finished")
	_set_players()
	DataSaver.save_formation(formations[index])
	animation_player.play("Fade" + DataSaver.selected_formation)
	

func _set_players():
	$Field/G.set_player(DataSaver.selected_players[0])
	$Field/D.set_player(DataSaver.selected_players[1])
	$Field/WL.set_player(DataSaver.selected_players[2])
	$Field/WR.set_player(DataSaver.selected_players[3])
	$Field/P.set_player(DataSaver.selected_players[4])


func _on_D_change_player(player):
	player_to_replace = player
	$PlayerSelect.popup_centered()


func _on_WL_change_player(player):
	player_to_replace = player
	$PlayerSelect.popup_centered()



func _on_WR_change_player(player):
	player_to_replace = player
	$PlayerSelect.popup_centered()


func _on_P_change_player(player):
	player_to_replace = player
	$PlayerSelect.popup_centered()


func _on_PlayerList_select_player(player):
	print("formation select")
	DataSaver.change_player(player_to_replace,player[0])
	_set_players()
