extends Control

var bold_label_settings:LabelSettings = load("res://theme/bold_label_settings.tres")

func bold(label:Label) -> void:
	label.label_settings = bold_label_settings
