extends Node

# to calculate bes supporting spot for players on field

func set_up(goal):
	for fieldspot in get_children():
		fieldspot.set_up(goal)
