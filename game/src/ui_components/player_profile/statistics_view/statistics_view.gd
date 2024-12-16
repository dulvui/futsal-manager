# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name StatisticsView
extends VBoxContainer


@onready var resource_view: ResourceView = %ResourceView


func setup(player: Player) -> void:
	# TODO setup seasons buttons

	resource_view.setup(player.statistics)


func _on_season_options_button_item_selected(_index: int) -> void:
	pass

