extends Control



func _ready():
	var pos = 1
	
	# transform table dictionary to array
	var table_array = []
	for key in DataSaver.table:
		table_array.append({
			"name" : key,
			"points" : DataSaver.table[key]["points"],
			"games_played": DataSaver.table[key]["games_played"],
			"goals_made" : DataSaver.table[key]["goals_made"],
			"goals_against" : DataSaver.table[key]["goals_against"],
			"wins" : DataSaver.table[key]["wins"],
			"draws" : DataSaver.table[key]["draws"],
			"lost" : DataSaver.table[key]["lost"]
		 })
		
	table_array.sort_custom(self,"point_sorter")
	
	
	for team in table_array:
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


func point_sorter(a, b):
	if a["points"] > b["points"]:
		return true
	elif a["points"] == b["points"] and a["goals_made"] - a["goals_against"] > b["goals_made"] - b["goals_against"]:
		return true
	return false


func _on_Close_pressed():
	hide()
