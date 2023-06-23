extends Control

signal click

@onready
var color_rect:ColorRect = $ColorRect

@onready
var match_button:Button = $MarginContainer/VBoxContainer/Match

@onready
var weekday_label:Label = $MarginContainer/VBoxContainer/HBoxContainer/WeekDay

@onready
var month_day_label:Label = $MarginContainer/VBoxContainer/HBoxContainer/MonthDay

# day button of calendar

# on click emits signal, to show match or training popup in calendar
# if something set, else do nothing

func set_up(day, current_day, current_month) -> void:
	month_day_label.text = str(current_day + 1)
	var team_name
	if day["matches"].size() > 0:
		for matchz in day["matches"]:
			if matchz != null:
				if DataSaver.team_name == matchz["home"]:
					team_name = matchz["away"]
					color_rect.color = Color.DODGER_BLUE
				elif DataSaver.team_name == matchz["away"]:
					team_name = matchz["home"]
					color_rect.color = Color.DEEP_SKY_BLUE
		match_button.pressed.connect(_on_Match_pressed.bind(day["matches"]))
		match_button.show()
		match_button.text = team_name
	if current_day == DataSaver.date.day and DataSaver.date.month == current_month:
		if color_rect.color != Color.DODGER_BLUE:
			color_rect.color = Color.RED
		elif color_rect.color != Color.DEEP_SKY_BLUE:
			color_rect.color = Color.DARK_RED
		else:
			color_rect.color = Color.LIGHT_PINK
			
	
	weekday_label.text = day["weekday"]


func _on_Match_pressed(matches) -> void:
	print("matchchh")
	for child in match_button.get_node("Popup/VBoxContainer").get_children():
		child.queue_free()
		
	for matchz in matches:
		var label = Label.new()
		print(matchz)
		label.text = matchz["home"] + " " + matchz["result"] + " " + matchz["away"]
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		match_button.get_node("Popup/VBoxContainer").add_child(label)
	match_button.get_node("Popup/VBoxContainer").popup_centered()


func _on_Close_pressed() -> void:
	match_button.get_node("Popup/VBoxContainer").hide()
