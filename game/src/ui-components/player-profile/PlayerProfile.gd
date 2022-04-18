extends Control

signal player_select

const DetailNumber = preload("res://src/ui-components/detail-number/DetailNumber.tscn")

var player = {}

func set_up_info(new_player,info_type):
	player = new_player
	
	$Info/Name.text = player["name"].substr(0,1) + ". " + player["surname"]
	$Info/General/Position.text = player["position"]
	$Info/General/Prestige.text = str(player["prestige"])
	
	# TODO create profile for goalpkeeper
	# AND make labels dynamic by keys
	
#	if player["position"] != "G":
#		for key in player["attributes"]["mental"].keys():
#			var value = DetailNumber.instance()
#			value.set_up(player["attributes"]["mental"][key])
#			$Info/Mental.add_child(value)
#
#		for key in player["attributes"]["physical"].keys():
#			var value = DetailNumber.instance()
#			value.set_up(player["attributes"]["physical"][key])
#			$Info/Fisical.add_child(value)
#
#		match info_type:
#			"GENERAL":
#				$Info/General.show()
#			"MENTAL":
#				$Info/Mental.show()
#			"FISICAL":
#				$Info/Fisical.show()
#
#		$DetailPopup/TabContainer/Info/Info/Position.text = player["position"]
#		$DetailPopup/TabContainer/Info/Info/Age.text = player["birth_date"]
#		$DetailPopup/TabContainer/Info/Info/Nationality.text = player["nationality"]
#		$DetailPopup/TabContainer/Info/Info/Team.text = str(player["prestige"])
#		$DetailPopup/TabContainer/Info/Info/Foot.text = player["foot"]
#		$DetailPopup/TabContainer/Info/Info/Nr.text = str(player["nr"])
#
#		for key in player["attributes"]["mental"].keys():
#			var label = $DetailPopup/TabContainer/Info/Mental.get_node(key)
#			label.set_up(player["attributes"]["mental"][key])
#
#		for key in player["attributes"]["fisical"].keys():
#			var label = $DetailPopup/TabContainer/Info/Fisical.get_node(key)
#			label.set_up(player["attributes"]["fisical"][key])
#
#		for key in player["attributes"]["technical"].keys():
#			var label = $DetailPopup/TabContainer/Info/Technical.get_node(key)
#			label.set_up(player["attributes"]["technical"][key])



func _on_Details_pressed():
	$DetailPopup.popup_centered()


func _on_Select_pressed():
	print("select in prfoile")
	emit_signal("player_select")


func _on_Hide_pressed():
	$DetailPopup.hide()
