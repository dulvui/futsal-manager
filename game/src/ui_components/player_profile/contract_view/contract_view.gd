# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ContractView
extends VBoxContainer


@onready var offer_button: Button = %Offer
@onready var resource_view: ResourceView = %ResourceView


func setup(player: Player) -> void:
	# show offer button, only for players that are not in your team
	if Global.team:
		offer_button.visible = not Global.team.players.has(player)

	resource_view.setup(player.contract)
