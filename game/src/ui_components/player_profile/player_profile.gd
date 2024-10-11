# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerProfile
extends VBoxContainer

signal offer(player: Player)
signal cancel

const ColorLabelScene: PackedScene = preload("res://src/ui_components/color_label/color_label.tscn")

var player: Player

@onready var info: Control = $Main/Info
@onready var attributes: Control = $Main/Attributes

@onready var player_name: Label = $Main/Info/Name
@onready var pos: Label = $Main/Info/Position
@onready var alt_pos: Label = $Main/Info/AltPosition
@onready var age: Label = $Main/Info/Age
@onready var foot: Label = $Main/Info/Foot
@onready var nationality: Label = $Main/Info/Nationality
@onready var team: Label = $Main/Info/Team
@onready var nr: Label = $Main/Info/Nr
@onready var attributes_average: Label = $Main/Info/AttributesAverage
@onready var prestige: Label = $Main/Info/Prestige
@onready var price: Label = $Main/Info/Price
@onready var goals: Label = $Main/History/Goals
@onready var offer_button: Button = $Buttons/Offer


func _ready() -> void:
	# setup automatically, if run in editor and is run by 'Run current scene'
	if OS.has_feature("editor") and get_parent() == get_tree().root:
		set_player(Tests.create_mock_player())


func set_player(p_player: Player) -> void:
	player = p_player
	
	# show offer button, only for players that are not in your team
	offer_button.visible = not Global.team.players.has(player)

	player_name.text = player.name + " " + player.surname
	pos.text = str(Position.Type.keys()[player.position.type])
	alt_pos.text = str(player.alt_positions.map(
		func(p: Position) -> String:
			return Position.Type.keys()[p.type]
			)
		)
	
	age.text = (
		str(player.birth_date.day)
		+ "/"
		+ str(player.birth_date.month)
		+ "/"
		+ str(player.birth_date.year)
	)
	foot.text = Player.Foot.keys()[player.foot]
	nationality.text = str(player.team)
	team.text = str(player.foot)
	nr.text = str(player.nr)
	attributes_average.text = str(player.get_overall())
	prestige.text = str(player.prestige)
	price.text = FormatUtil.get_sign(player.price)

	# attributes
	for attribute: String in Const.ATTRIBUTES.keys():
		# first remove existing values
		for child: Node in attributes.get_node(attribute.capitalize()).get_children():
			child.queue_free()

		# add title and a empty label
		var label_title: Label = Label.new()
		label_title.text = tr(attribute.to_upper())
		attributes.get_node(attribute.capitalize()).add_child(label_title)
		attributes.get_node(attribute.capitalize()).add_child(Label.new())

		for key: String in Const.ATTRIBUTES[attribute]:
			var label: Label = Label.new()
			label.text = tr(key.to_upper())
			label.tooltip_text = tr(key.to_upper())
			#label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			attributes.get_node(attribute.capitalize()).add_child(label)
			var value: ColorLabel = ColorLabelScene.instantiate()
			attributes.get_node(attribute.capitalize()).add_child(value)
			value.set_up(key)
			value.set_value(player.get_res_value(["attributes", attribute, key]))

	#history
	goals.text = str(player.statistics.goals)


func _on_offer_pressed() -> void:
	offer.emit(player)


func _on_close_pressed() -> void:
	cancel.emit()
