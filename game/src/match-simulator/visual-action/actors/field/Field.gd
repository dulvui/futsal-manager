extends Node2D


onready var home_goal_center = $HomeGoal.global_position
onready var away_goal_center = $AwayGoal.global_position

onready var width = $Floor.texture.get_width()
onready var height = $Floor.texture.get_height()

