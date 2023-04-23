extends Control


func set_up(value:int) -> void:
	$Label.text = str(value)
	
	if value < 11 :
		$Label.label_settings.font_color = Color.RED
	elif value < 16:
		$Label.label_settings.font_color = Color.BLUE
	else:
		$Label.label_settings.font_color = Color.DARK_GREEN
