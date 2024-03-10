extends Control

var bold_label_settings:LabelSettings = load("res://theme/bold_label_settings.tres")
var label_settings:LabelSettings = load("res://theme/label_settings.tres")


func bold(label:Label) -> void:
	label.label_settings = bold_label_settings
	
func remove_bold(label:Label) -> void:
	label.label_settings = label_settings
