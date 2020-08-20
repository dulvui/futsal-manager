extends Control


func set_up_info(player):
	print(player)
	$Name.text = player["name"]
	$Info/Position.text = player["position"]
	$Info/Age.text = player["birth_date"]
	$Info/Nationality.text = player["nationality"]
	$Info/Team.text = player["team"]
	
	var tech = player["stats"]["technial"]
	$Technical/Cross.text = str(tech["crossing"])
	$Technical/Pass.text = str(tech["pass"])
	$Technical/LongPass.text = str(tech["long_pass"])
	$Technical/Tackling.text = str(tech["tackling"])
	$Technical/Corner.text = str(tech["corners"])
	
	var mental = player["stats"]["mental"]
	$Mental/Agressivity.text = str(mental["agressivity"])
	$Mental/Anticipation.text = str(mental["aniticipation"])
	$Mental/Decisions.text = str(mental["decisions"])
	$Mental/Concentration.text = str(mental["concentration"])
	$Mental/Teamwork.text = str(mental["teamwork"])
