extends Control


func set_up(value:int) -> void:
	$Label.text = str(value)
	
	var label_settings:LabelSettings = LabelSettings.new()
	
	if value < 11 :
		label_settings.font_color = Color.RED
	elif value < 16:
		label_settings.font_color = Color.BLUE
	else:
		label_settings.font_color = Color.DARK_GREEN
	
	$Label.label_settings = label_settings
