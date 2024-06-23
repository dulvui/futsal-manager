# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualFormation
extends HBoxContainer

signal change

const FormationPlayer: PackedScene = preload(
	"res://src/ui_components/visual_formation/player/formation_player.tscn"
)

@onready var players: VBoxContainer = $LineUp/Field/Players
@onready var subs: VBoxContainer = $Subs/List

@onready var formation_select: SwitchOptionButton = $Tactics/FormationSelect

@onready var tactic_select_offense: SwitchOptionButton = $Tactics/TacticSelectOffense
@onready var tactic_offense_intensity: HSlider = $Tactics/TacticOffenseIntensity

@onready var tactic_select_pressing: SwitchOptionButton = $Tactics/TacticSelectPressing
@onready var tactic_select_marking: SwitchOptionButton = $Tactics/TacticSelectMarking


@onready var goalkeeper: HBoxContainer = $LineUp/Field/Players/Goalkeeper
@onready var defense: HBoxContainer = $LineUp/Field/Players/Defense
@onready var center: HBoxContainer = $LineUp/Field/Players/Center
@onready var attack: HBoxContainer = $LineUp/Field/Players/Attack

var change_players: Array[int] = []

var team: Team
var only_lineup: bool

func _ready() -> void:
	# setup automatically, if run in editor and is run by 'Run current scene'
	if OS.has_feature("editor") and get_parent() == get_tree().root:
		set_up(false)


func set_up(p_only_lineup: bool) -> void:
	only_lineup = p_only_lineup
	team = Config.team

	# set up fomation options
	formation_select.set_up(Formation.Variations.keys(), team.formation.variation)
	
	# tactics offense
	tactic_select_offense.set_up(TacticOffense.Tactics.keys(), \
		TacticOffense.Tactics.values()[team.formation.tactic_offense.tactic])
	
	tactic_offense_intensity.value = team.formation.tactic_offense.intensity
	
	# tactics defense
	tactic_select_marking.set_up(TacticDefense.Marking.keys(), \
		TacticDefense.Marking.values()[team.formation.tactic_defense.marking])
	tactic_select_pressing.set_up(TacticDefense.Pressing.keys(), \
		TacticDefense.Pressing.values()[team.formation.tactic_defense.pressing])

	_set_players()


func _set_players() -> void:
	# clean field
	for hbox: HBoxContainer in players.get_children():
		for player: Control in hbox.get_children():
			player.queue_free()

	# clean subs
	for sub: Control in subs.get_children():
		sub.queue_free()

	var pos_count: int = 0
	# add golakeeper
	if team.formation.goalkeeper > 0:
		var formation_goal_keeper: VisualFormationPlayer = FormationPlayer.instantiate()
		formation_goal_keeper.set_player(team.get_goalkeeper(), team)
		formation_goal_keeper.change_player.connect(
			_on_select_player.bind(formation_goal_keeper.player.id)
		)
		goalkeeper.add_child(formation_goal_keeper)
		pos_count += 1

	# add defenders
	for i: int in team.formation.defense:
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(
			_on_select_player.bind(formation_player.player.id)
		)
		defense.add_child(formation_player)
		pos_count += 1

	# add center
	for i: int in team.formation.center:
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(
			_on_select_player.bind(formation_player.player.id)
		)
		center.add_child(formation_player)
		pos_count += 1

	# add attack
	for i: int in team.formation.attack:
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(
			_on_select_player.bind(formation_player.player.id)
		)
		attack.add_child(formation_player)
		pos_count += 1

	# add subs
	var subs_label: Label = Label.new()
	subs_label.text = "SUBS"
	subs_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subs.add_child(subs_label)
	
	for i: int in team.get_sub_players().size():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		formation_player.set_player(team.get_lineup_player(pos_count), team)
		formation_player.change_player.connect(
			_on_select_player.bind(formation_player.player.id)
		)
		subs.add_child(formation_player)
		pos_count += 1
	
	subs.add_child(HSeparator.new())
	# add non lineup players
	var non_lineup_label: Label = Label.new()
	non_lineup_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	non_lineup_label.text = "REST"
	subs.add_child(non_lineup_label)
	
	for p: Player in team.get_non_lineup_players():
		var formation_player: VisualFormationPlayer = FormationPlayer.instantiate()
		formation_player.set_player(p, team)
		formation_player.change_player.connect(
			_on_select_player.bind(formation_player.player.id)
		)
		subs.add_child(formation_player)


func _update_formation(index: int) -> void:
	team.formation = Formation.new(index)
	_set_players()


func _on_select_player(id: int) -> void:
	if id not in change_players:
		change_players.append(id)
		if change_players.size() == 2:
			_change_player()
	else:
		change_players.erase(id)


func _change_player() -> void:
	# switch betwenn list and lineup
	if change_players.size() == 2:
		team.change_players(change_players[0], change_players[1])
	else:
		print("error in substitution")
		return

	_set_players()
	change.emit()

	change_players.clear()


func _on_formation_button_item_selected(index: int) -> void:
	_update_formation(index)


func _on_tactic_select_offense_item_selected(index: int) -> void:
	team.formation.tactic_offense.tactic = index


func _on_tactic_select_marking_item_selected(index: int) -> void:
	team.formation.tactic_defense.marking = index


func _on_tactic_select_pressing_item_selected(index: int) -> void:
	team.formation.tactic_defense.pressing = index


func _on_tactic_offense_intensity_value_changed(value: float) -> void:
	team.formation.tactic_offense.intensity = int(value)
