extends Control


func _ready():
	var pos = 1
	for team in DataSaver.table:
		var pos_label = Label.new()
		pos_label.text = str(pos)
		pos += 1
		$GridContainer.add_child(pos_label)
		
		var name_label = Label.new()
		name_label.text = team["name"]
		$GridContainer.add_child(name_label)
		
		var games_played_label = Label.new()
		games_played_label.text = str(team["wins"] + team["draws"] + team["lost"])
		$GridContainer.add_child(games_played_label)

		var wins_label = Label.new()
		wins_label.text = str(team["wins"])
		$GridContainer.add_child(wins_label)
		
		var draws_label = Label.new()
		draws_label.text = str(team["draws"])
		$GridContainer.add_child(draws_label)
		
		var lost_label = Label.new()
		lost_label.text = str(team["lost"])
		$GridContainer.add_child(lost_label)
		
		var goals_made_label = Label.new()
		goals_made_label.text = str(team["goals_made"])
		$GridContainer.add_child(goals_made_label)
		
		var goals_against_label = Label.new()
		goals_against_label.text = str(team["goals_against"])
		$GridContainer.add_child(goals_against_label)
		
		var points_label = Label.new()
		points_label.text = str(team["points"])
		$GridContainer.add_child(points_label)
