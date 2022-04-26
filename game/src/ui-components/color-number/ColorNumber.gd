extends Control


func set_up(value):
	$Label.text = str(value)
	
	if value < 11 :
		$Label.add_color_override("font_color", Color.red)
	elif value < 16:
		$Label.add_color_override("font_color", Color.blue)
	else:
		$Label.add_color_override("font_color", Color.darkgreen)
