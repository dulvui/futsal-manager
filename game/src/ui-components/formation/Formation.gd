extends Control

signal change

onready var animation_player = $AnimationPlayer

var formations = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]

var player_to_replace


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	for formation in formations:
		$FormationSelect.add_item(formation)
		
	$FormationSelect.selected = formations.find("2-2")
#	$FormationSelect.selected = formations.find(DataSaver.team["formation"])
		
	_set_players()
	
#	$OffensiveTactics/O1.value = DataSaver.team["offensive_tactics"]["O1"]
#	$OffensiveTactics/O2.value = DataSaver.team["offensive_tactics"]["O2"]
#	$OffensiveTactics/O3.value = DataSaver.team["offensive_tactics"]["O3"]
#	$OffensiveTactics/O4.value = DataSaver.team["offensive_tactics"]["O4"]
#
#	$DefensiveTactics/D1.value = DataSaver.team["defensive_tactics"]["D1"]
#	$DefensiveTactics/D2.value = DataSaver.team["defensive_tactics"]["D2"]
#	$DefensiveTactics/D3.value = DataSaver.team["defensive_tactics"]["D3"]
#	$DefensiveTactics/D4.value = DataSaver.team["defensive_tactics"]["D4"]

#	$OffensiveTactics/O1.value = 10
#	$OffensiveTactics/O2.value = 10
#	$OffensiveTactics/O3.value = 10
#	$OffensiveTactics/O4.value = 10
#
#	$DefensiveTactics/D1.value = 10
#	$DefensiveTactics/D2.value = 10
#	$DefensiveTactics/D3.value = 10
#	$DefensiveTactics/D4.value = 10
		
	animation_player.play("Fade" + DataSaver.formation)

func _on_FormationSelect_item_selected(index):
	animation_player.play_backwards("Fade" + DataSaver.formation)
	yield(animation_player,"animation_finished")
	_set_players()
	DataSaver.formation = formations[index]
	DataSaver.save_all_data()
	animation_player.play("Fade" + DataSaver.formation)
	

func _set_players():
	var team = DataSaver.get_selected_team()
	$PlayerList.add_subs()
	$Field/G.set_player(team["players"]["active"][0])
	$Field/D.set_player(team["players"]["active"][1])
	$Field/WL.set_player(team["players"]["active"][2])
	$Field/WR.set_player(team["players"]["active"][3])
	$Field/P.set_player(team["players"]["active"][4])
	


func _on_D_change_player(player):
	player_to_replace = 1
	$PlayerList.show()


func _on_WL_change_player(player):
	player_to_replace = 2
	$PlayerList.show()



func _on_WR_change_player(player):
	player_to_replace = 3
	$PlayerList.show()


func _on_P_change_player(player):
	player_to_replace = 4
	$PlayerList.show()
	
func _on_G_change_player(player):
	player_to_replace = 0
	$PlayerList.show()

func _on_PlayerList_select_player(player):
	print("formation select")
	DataSaver.change_player(player_to_replace,player)
	_set_players()
	$PlayerList.hide()
	emit_signal("change")


#func _on_D1_value_changed(value):
#	DataSaver.team["defensive_tactics"]["D1"] = value
#
#
#func _on_D2_value_changed(value):
#	DataSaver.team["defensive_tactics"]["D2"] = value
#
#
#func _on_D3_value_changed(value):
#	DataSaver.team["defensive_tactics"]["D3"] = value
#
#
#func _on_D4_value_changed(value):
#	DataSaver.team["defensive_tactics"]["D4"] = value
#
#
#func _on_O1_value_changed(value):
#	DataSaver.team["offensive_tactics"]["O1"] = value
#
#
#func _on_O2_value_changed(value):
#	DataSaver.team["offensive_tactics"]["O2"] = value
#
#
#func _on_O3_value_changed(value):
#	DataSaver.team["offensive_tactics"]["O3"] = value
#
#
#func _on_O4_value_changed(value):
#	DataSaver.team["offensive_tactics"]["O4"] = value


func _on_D1Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("D1_INFO")
	$TacticInfoPopUp.popup_centered()

func _on_D2Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("D2_INFO")
	$TacticInfoPopUp.popup_centered()
	


func _on_D3Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("D3_INFO")
	$TacticInfoPopUp.popup_centered()


func _on_D4Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("D4_INFO")
	$TacticInfoPopUp.popup_centered()


func _on_01Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("O1_INFO")
	$TacticInfoPopUp.popup_centered()


func _on_02Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("O2_INFO")
	$TacticInfoPopUp.popup_centered()


func _on_03Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("O3_INFO")
	$TacticInfoPopUp.popup_centered()


func _on_04Info_pressed():
	$TacticInfoPopUp/TacticInfo.text = tr("O4_INFO")
	$TacticInfoPopUp.popup_centered()


func _on_Close_pressed():
	hide()
