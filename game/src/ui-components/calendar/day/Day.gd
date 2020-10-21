extends Control

signal click

# day button of calendar

# on click emits signal, to show match or training popup in calendar
# if something set, else do nothing

func set_up(day):
	$Label.text = str(day["day"])
	if day["matches"].size() > 0:
		$Match.text = "M"
