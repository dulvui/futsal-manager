# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Popup



func show_matches(matches:Array):
	var label_settings:LabelSettings = LabelSettings.new()
	label_settings.font_size = get_theme_default_font_size()
	label_settings.font_color = Color.GOLD
	
	for matchz in matches:
		var home_label = Label.new()
		home_label.text = matchz["home"]
		home_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		home_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		var result_label = Label.new()
		if matchz["result"] == ":":
			result_label.text = "vs"
		else:
			result_label.text = matchz["result"]
		result_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var away_label = Label.new()
		away_label.text = matchz["away"]
		away_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		away_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		if matchz["home"] == Config.team.name or matchz["away"] == Config.team.name:
			home_label.label_settings = label_settings
			result_label.label_settings = label_settings
			away_label.label_settings = label_settings
			
		
		$MarginContainer/GridContainer.add_child(home_label)
		$MarginContainer/GridContainer.add_child(result_label)
		$MarginContainer/GridContainer.add_child(away_label)
		
	popup_centered()
