extends Label

func set_up(value):
	text = str(value)
	if value < 11 :
		add_color_override("font_color", Color.red)
	elif value < 16:
		add_color_override("font_color", Color.blue)
	else:
		add_color_override("font_color", Color.green)
