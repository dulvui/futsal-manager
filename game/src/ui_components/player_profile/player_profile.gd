# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerProfile
extends VBoxContainer

signal offer(player: Player)


var player: Player

@onready var info_view: InfoView = %INFO
@onready var attributes_view: AttributesView = %ATTRIBUTES

@onready var goals: Label = %Goals
@onready var offer_button: Button = %Offer


func _ready() -> void:
	# setup automatically, if run in editor and is run by 'Run current scene'
	if OS.has_feature("editor") and get_parent() == get_tree().root:
		set_player(Tests.create_mock_player())


func set_player(p_player: Player) -> void:
	player = p_player

	# show offer button, only for players that are not in your team
	if Global.team:
		offer_button.visible = not Global.team.players.has(player)

	info_view.setup(player)
	attributes_view.setup(player)

	#history
	goals.text = str(player.statistics.goals)


func _on_offer_pressed() -> void:
	offer.emit(player)

