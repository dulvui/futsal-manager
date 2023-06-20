extends MarginContainer


func update_stats(home_stats:Dictionary, away_stats:Dictionary) -> void:
	$VBoxContainer/HomePossession.text = "%d "%home_stats["possession"] + "%"
	$VBoxContainer/AwayPossession.text = "%d "%away_stats["possession"] + "%"
	$VBoxContainer/HomePass.text = "%d "%home_stats["passes"]
	$VBoxContainer/AwayPass.text = "%d "%away_stats["passes"]
	$VBoxContainer/HomePassSuccess.text = "%d "%home_stats["passes_success"]
	$VBoxContainer/AwayPassSuccess.text = "%d "%away_stats["passes_success"]
	$VBoxContainer/HomeShots.text = "%d "%home_stats["shots"]
	$VBoxContainer/AwayShots.text = "%d "%away_stats["shots"]
	$VBoxContainer/AwayShotsOnTarget.text = "%d "%away_stats["shots_on_target"]
	$VBoxContainer/HomeShotsOnTarget.text = "%d "%home_stats["shots_on_target"]
	$VBoxContainer/HomeCorners.text = "%d "%home_stats["corners"]
	$VBoxContainer/AwayCorners.text = "%d "%away_stats["corners"]
	$VBoxContainer/HomeThrowIn.text = "%d "%home_stats["kick_ins"]
	$VBoxContainer/AwayThrowIn.text = "%d "%away_stats["kick_ins"]
	$VBoxContainer/HomeFouls.text = "%d "%home_stats["fouls"]
	$VBoxContainer/AwayFouls.text = "%d "%away_stats["fouls"]
	$VBoxContainer/HomeFreeKicks.text = "%d "%home_stats["free_kicks"]
	$VBoxContainer/AwayFreeKicks.text = "%d "%away_stats["free_kicks"]
	$VBoxContainer/HomePenalties.text = "%d "%home_stats["penalties"]
	$VBoxContainer/AwayPenalties.text = "%d "%away_stats["penalties"]
	$VBoxContainer/HomeYellowCards.text = "%d "%home_stats["yellow_cards"]
	$VBoxContainer/AwayYellowCards.text = "%d "%away_stats["yellow_cards"]
	$VBoxContainer/HomeRedCards.text = "%d "%home_stats["red_cards"]
	$VBoxContainer/AwayRedCards.text = "%d "%away_stats["red_cards"]
	
