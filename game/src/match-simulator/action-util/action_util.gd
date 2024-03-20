# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

# Action util that handles every action of the game.
# First the player with the ball attacks and the corresponding player of
# the other team reposonds with a defense action and accordign to individual
# player attributes and team tactics a result gets calculated.

extends Node

class_name ActionUtil


signal possession_change
signal shot(player:Player, on_target:bool, goal:bool)
signal pazz(player:Player, success:bool)
signal foul(player:Player)
signal penalty(player:Player)
signal freekick(player:Player)
signal corner(player:Player)
signal red_card(player:Player)
signal kick_in(player:Player)
signal yellow_card(player:Player)

signal action_message



enum Cards {NONE, YELLOW, RED}
#enum Pass { SHORT_PASS, LONG_PASS, CROSS}
#enum Shoot {SHOOT, LONG_SHOOT, HEADER}

@onready var home_team:Node = $HomeTeam
@onready var away_team:Node = $AwayTeam

var current_state:Action.State

const MAX_ACTION_BUFFER_SIZE:int = 8 
var action_buffer:Array[Action] = []

var attacking_player:Player
var defending_player:Player


func _ready() -> void:
	randomize()

func set_up(_home_team:Team, _away_team:Team) -> void:
	home_team.set_up(_home_team)
	away_team.set_up(_away_team)
	
	current_state = Action.State.KICK_OFF
	
	_change_active_players()


func update() -> void:
	current_state = Action.State.NORMAL
	
	var attack:int = _random_attack()
	var attack_success:bool = _get_attack_result(attack)
	
	_log(attack, attack_success)
	_action_buffer(attack, attack_success)
	# change active players and possession
	if attack_success:
		match attack:
			Action.Attack.PASS: # , AttackCROSS
				_change_active_players()
			Action.Attack.RUN, Action.Attack.DRIBBLE:
				_change_defender()
			Action.Attack.SHOOT: # , Action.Attack.HEADER
				if _check_goal():
					shot.emit(attacking_player, true, true)
					_change_possession()
				else:
					# TODO emit corner signal for visual action
					_check_corner()
	else:
		# increase stats
		match attack:
			Action.Attack.PASS:
				pazz.emit(attacking_player, false)
			Action.Attack.SHOOT:
				var random_on_target:int = randi() % Constants.MAX_FACTOR
				shot.emit(attacking_player, random_on_target > Constants.SHOOT_ON_TARGET_FACTOR, false)
		
		if _check_foul():
			var card:Cards = _check_card()
			action_message.emit("Foul with " + Cards.keys()[card] + " card.")
			
			# check penalty or freekick
			var random:int = randi() % Constants.MAX_FACTOR
			if random > Constants.PENALTY_FACTOR:
				action_message.emit("FREE_KICK")
				current_state = Action.State.FREE_KICK
				freekick.emit(attacking_player)
			else:
				action_message.emit("PENALTY")
				current_state = Action.State.PENALTY
				penalty.emit(attacking_player)
		else:
			# TODO emit kickin signal for visual action
			if _check_kick_in():
				current_state = Action.State.KICK_IN
				kick_in.emit(attacking_player)
		_change_possession()
		_change_attacker()

	home_team.update_players()
	away_team.update_players()

	
func change_players(_home_team:Team,_away_team:Team) -> void:
	# reset action buffer, becasue change happened and
	# changed player is not visible in field anymore
	action_buffer = []
	home_team.set_up(_home_team)
	away_team.set_up(_away_team)
	
# returns true if attack wins, false if defense wins
func _get_attack_result(attack:int) -> bool:
	# select attributes to use as value for random result calculation
	var attacker_attributes:int = 0
	var defender_attributes:int = 0
	
	if current_state == Action.State.NORMAL:
			attacker_attributes = attacking_player.get_attack_attributes(attack)
			defender_attributes = defending_player.get_defense_attributes(attack)
	else:
		return true
	
	# calculate random action winner
	var max_value:int = attacker_attributes + defender_attributes
	var random:int = randi() % int(max_value)
	var result:bool = false
	
	if random < attacker_attributes:
		result = true
	return result
	
func _random_attack() -> int:
	# improve later watching current sector and player attributes
	match current_state:
		Action.State.KICK_OFF, Action.State.KICK_IN:
			return Action.Attack.PASS
		Action.State.PENALTY, Action.State.FREE_KICK, Action.State.PENALTY:
			return Action.Attack.SHOOT
		Action.State.CORNER:
			if randi() % 2 == 0: # use player preferences/attirbutes
				return Action.Attack.CROSS
			else:
				return Action.Attack.PASS
		_:
			var random_attack_factor:int = _get_attack_factor()
			if random_attack_factor < Constants.PASS_FACTOR:
				return Action.Attack.RUN
			elif random_attack_factor < Constants.RUN_FACTOR:
				return Action.Attack.PASS
			elif random_attack_factor < Constants.DRIBBLE_FACTOR:
				return Action.Attack.DRIBBLE
			else:
				return Action.Attack.SHOOT
				
func _get_attack_factor() -> int:
	# max factor is 1000 and shoot factor is 950
	# remove positions size, and player position again
	# so shooting factor is harder to get for lower positions like defenders
	var factor:int = randi() % (Constants.ATTACK_FACTOR - Player.Position.size() * 10)
	factor += attacking_player.position * 10
	return factor

func _log(attack:int, result:bool) -> void:
	action_message.emit(home_team.active_player.name + " vs " + away_team.active_player.name + " " + str(Action.Attack.keys()[attack]) + " - " + str(result))

func _action_buffer(attack:int, result:bool) -> void:
	var action:Action = Action.new()
	action.attack = Action.Attack.keys()[attack]
	action.state = Action.State.keys()[current_state]
	action.is_home = home_team.has_ball
	action.success = result
	action.attacking_player = attacking_player
	action.defending_player = defending_player
	
	action_buffer.append(action)
	
	if action_buffer.size() > MAX_ACTION_BUFFER_SIZE:
		action_buffer.pop_front()

func _check_goal() -> bool:
	var goalkeeper_attributes:int
	if home_team.has_ball:
		goalkeeper_attributes = away_team.goalkeeper.get_goalkeeper_attributes()
	else:
		goalkeeper_attributes = home_team.goalkeeper.get_goalkeeper_attributes()
	
	var random_goal:int = randi() % int(goalkeeper_attributes)
	goalkeeper_attributes *= Constants.GOAL_KEEPER_FACTOR[Action.State.keys()[current_state]]
	
	#decrease more if away keeper has to save
	if home_team.has_ball:
		goalkeeper_attributes *= Constants.GOAL_KEEPER_AWAY_FACTOR
	
	if random_goal > goalkeeper_attributes:
		return true
	return false
	
	
# ACTION EVENT CHECKS
func _check_corner() -> bool:
	var random:int = randi() % Constants.MAX_FACTOR
	if random < Constants.CORNER_AFTER_SAFE_FACTOR:
		return true
	return false
	
func _check_foul() -> bool:
	var random:int = randi() % Constants.MAX_FACTOR
	if random < Constants.FOUL_FACTOR:
		foul.emit(defending_player)
		return true
	return false

	
func _check_card() -> Cards:
	var random:int = randi() % Constants.MAX_FACTOR
	if random > Constants.RED_CARD_FACTOR:
		red_card.emit(defending_player)
		return Cards.RED
	elif random > Constants.YELLOW_CARD_FACTOR:
		yellow_card.emit(defending_player)
		return Cards.YELLOW
	return Cards.NONE
	
func _check_kick_in() -> bool:
	var random:int = randi() % Constants.MAX_FACTOR
	if random < Constants.KICK_IN_FACTOR:
		current_state = Action.State.KICK_IN
		kick_in.emit(attacking_player)
		return true
	return false

# PLAYER/POSSESSION CHANGE
func _change_possession() -> void:
	possession_change.emit()
	home_team.has_ball = not home_team.has_ball
	away_team.has_ball = not away_team.has_ball
	
func _change_active_players() -> void:
	if home_team.has_ball:
		attacking_player = home_team.change_active_player()
		defending_player = away_team.change_active_player()
	else:
		defending_player = home_team.change_active_player()
		attacking_player = away_team.change_active_player()
	
func _change_defender() -> void:
	if home_team.has_ball:
		defending_player = away_team.change_active_player()
	else:
		defending_player = home_team.change_active_player()

func _change_attacker() -> void:
	if away_team.has_ball:
		attacking_player = away_team.change_active_player()
	else:
		attacking_player = home_team.change_active_player()
