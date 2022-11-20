extends Control

signal change

onready var animation_player = $AnimationPlayer

var formations = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]

var player_to_replace

func _ready():
	for formation in formations:
		$FormationSelect.add_item(formation)
		
	$FormationSelect.selected = formations.find("2-2")
	_set_active_players()
	$PlayerList.set_up(true, false)
	animation_player.play("Fade" + DataSaver.get_selected_team()["formation"])

func _on_FormationSelect_item_selected(index):
	animation_player.play_backwards("Fade" + DataSaver.get_selected_team()["formation"] )
	yield(animation_player,"animation_finished")
	_set_active_players()
	DataSaver.get_selected_team()["formation"] = formations[index]
	DataSaver.save_all_data()
	animation_player.play("Fade" + DataSaver.get_selected_team()["formation"] )

func _set_active_players():
	var team = DataSaver.get_selected_team()
	$Field/G.set_player(team["players"]["active"][0])
	$Field/D.set_player(team["players"]["active"][1])
	$Field/WL.set_player(team["players"]["active"][2])
	$Field/WR.set_player(team["players"]["active"][3])
	$Field/P.set_player(team["players"]["active"][4])

func _on_D_change_player(_player):
	player_to_replace = 1
	$PlayerList.show()

func _on_WL_change_player(_player):
	player_to_replace = 2
	$PlayerList.show()

func _on_WR_change_player(_player):
	player_to_replace = 3
	$PlayerList.show()

func _on_P_change_player(_player):
	player_to_replace = 4
	$PlayerList.show()
	
func _on_G_change_player(_player):
	player_to_replace = 0
	$PlayerList.show()

func _on_PlayerList_select_player(_player):
	print("formation select")
	_change_player(_player)
	_set_active_players()
	$PlayerList.set_up(true, false)
	$PlayerList.hide()
	emit_signal("change")
	
func _change_player(player):
	var team = DataSaver.get_selected_team()
	team["players"]["subs"].append(team["players"]["active"][player_to_replace])
	team["players"]["active"][player_to_replace] = player
	team["players"]["subs"].erase(player)

func _on_Close_pressed():
	hide()
