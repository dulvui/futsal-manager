extends MarginContainer


func update_stats(home_stats, away_stats):
	$VBoxContainer/HomePossession.text = "%d "%home_stats.statistics["possession"]
	$VBoxContainer/AwayPossession.text = "%d "%away_stats.statistics["possession"]
	$VBoxContainer/HomePass.text = "%d "%home_stats.statistics["pass"]
	$VBoxContainer/AwayPass.text = "%d "%away_stats.statistics["pass"]
	$VBoxContainer/HomePassSuccess.text = "%d "%home_stats.statistics["pass_success"]
	$VBoxContainer/AwayPassSuccess.text = "%d "%away_stats.statistics["pass_success"]
	$VBoxContainer/HomeShots.text = "%d "%home_stats.statistics["shots"]
	$VBoxContainer/AwayShots.text = "%d "%away_stats.statistics["shots"]
	$VBoxContainer/AwayShotsOnTarget.text = "%d "%away_stats.statistics["shots_on_target"]
	$VBoxContainer/HomeShotsOnTarget.text = "%d "%home_stats.statistics["shots_on_target"]
	$VBoxContainer/HomeCorners.text = "%d "%home_stats.statistics["corners"]
	$VBoxContainer/AwayCorners.text = "%d "%away_stats.statistics["corners"]
	$VBoxContainer/HomeThrowIn.text = "%d "%home_stats.statistics["kick_ins"]
	$VBoxContainer/AwayThrowIn.text = "%d "%away_stats.statistics["kick_ins"]
	$VBoxContainer/HomeFouls.text = "%d "%home_stats.statistics["fouls"]
	$VBoxContainer/AwayFouls.text = "%d "%away_stats.statistics["fouls"]
	$VBoxContainer/HomeFreeKicks.text = "%d "%home_stats.statistics["free_kicks"]
	$VBoxContainer/AwayFreeKicks.text = "%d "%away_stats.statistics["free_kicks"]
	$VBoxContainer/HomePenalties.text = "%d "%home_stats.statistics["penalties"]
	$VBoxContainer/AwayPenalties.text = "%d "%away_stats.statistics["penalties"]
	$VBoxContainer/HomeYellowCards.text = "%d "%home_stats.statistics["yellow_cards"]
	$VBoxContainer/AwayYellowCards.text = "%d "%away_stats.statistics["yellow_cards"]
	$VBoxContainer/HomeRedCards.text = "%d "%home_stats.statistics["red_cards"]
	$VBoxContainer/AwayRedCards.text = "%d "%away_stats.statistics["red_cards"]
	
