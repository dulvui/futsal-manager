extends Control

onready var animation_player = $AnimationPlayer

var formations = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]

var player_to_replace


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	for formation in formations:
		$FormationSelect.add_item(formation)
		
	$FormationSelect.selected = formations.find(DataSaver.team["formation"])
		
		
	$PlayerSelect/PlayerList.add_players()
		
	
	
	_set_players()
		
	animation_player.play("Fade" + DataSaver.team["formation"])

func _on_FormationSelect_item_selected(index):
	animation_player.play_backwards("Fade" + DataSaver.team["formation"])
	yield(animation_player,"animation_finished")
	_set_players()
	DataSaver.team["formation"] = formations[index]
	DataSaver.save_all_data()
	animation_player.play("Fade" + DataSaver.team["formation"])
	

func _set_players():
	
	for player in DataSaver.team["players"]:
		match player["actual_pos"]:
			"G":
				$Field/G.set_player(player)
			"D":
				$Field/D.set_player(player)
			"WL":
				$Field/WL.set_player(player)
			"WR":
				$Field/WR.set_player(player)
			"P":
				$Field/P.set_player(player)


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
	
func _on_G_change_player(player):
	player_to_replace = player
	$PlayerSelect.popup_centered()

func _on_PlayerList_select_player(player):
	print("formation select")
	DataSaver.change_player(player_to_replace,player[0])
	_set_players()
	$PlayerSelect.hide()


func _on_D1_value_changed(value):
	pass # Replace with function body.


func _on_D2_value_changed(value):
	pass # Replace with function body.


func _on_D3_value_changed(value):
	pass # Replace with function body.


func _on_D4_value_changed(value):
	pass # Replace with function body.


func _on_O1_value_changed(value):
	pass # Replace with function body.


func _on_O2_value_changed(value):
	pass # Replace with function body.


func _on_O3_value_changed(value):
	pass # Replace with function body.
