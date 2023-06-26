extends Control

signal click

const MatchList:PackedScene = preload("res://src/ui-components/calendar/match-list/MatchList.tscn")

@onready
var color_rect:ColorRect = $ColorRect

@onready
var match_button:Button = $MarginContainer/VBoxContainer/Match

@onready
var month_day_label:Label = $MarginContainer/VBoxContainer/MonthDay

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
		match_button.text = team_name
	else:
		match_button.hide()
		
	if current_day == DataSaver.date.day and DataSaver.date.month == current_month:
		if color_rect.color != Color.DODGER_BLUE:
			color_rect.color = Color.LIGHT_GREEN
		elif color_rect.color != Color.DEEP_SKY_BLUE:
			color_rect.color = Color.MEDIUM_SPRING_GREEN
		else:
			color_rect.color = Color.LIGHT_PINK
			
	


func _on_Match_pressed(matches) -> void:
	var match_list = MatchList.instantiate()
	add_child(match_list)
	match_list.show_matches(matches)

func _on_Close_pressed() -> void:
	$MatchPopup.hide()
