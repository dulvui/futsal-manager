# Action util that handles every action of the game.
# First the player with the ball attacks and the corresponding player of
# the other team reposonds with a defense action and accordign to individual
# player attributes and team tactics a result gets calculated.

extends Node

class_name ActionUtil


signal possession_change
# signals for visual actions
# 2 param: boolean is_goal, is_home
signal shot
# TODO
signal penalty
signal freekick
signal corner

signal action_message

# in which sector of the field the player is situated
# so better decisions can be made depeneding on the sector a player is
enum Sector {ATTACK, CENTER, DEFENSE}
enum State {NORMAL, KICK_OFF, PENALTY, FREE_KICK, KICK_IN, CORNER}

enum Defense {INTERCEPT, WAIT, TACKLE, RUN, BLOCK, HEADER}

enum Attack {PASS, CROSS, DRIBBLE, RUN, SHOOT}
#enum Pass { SHORT_PASS, LONG_PASS, CROSS}
#enum Shoot {SHOOT, LONG_SHOOT, HEADER}

onready var home_team = $HomeTeam
onready var away_team = $AwayTeam

onready var home_stats = $HomeStatistics
onready var away_stats = $AwayStatistics

var current_state

const MAX_ACTION_BUFFER_SIZE = 10
var action_buffer = []

func _ready():
	randomize()

func set_up(_home_team, _away_team):
	home_team.set_up(_home_team)
	away_team.set_up(_away_team)
	
	current_state = State.KICK_OFF


func update(time):
	var attack = _attack()
	var attack_success = _get_result(attack)
	
	var foul = false
	var goal = false
	var corner = false
	var kick_in = false
	
	# change active players and possession
	if attack_success:
		match attack:
			Attack.PASS: # , AttackCROSS
				_change_players()
			Attack.RUN, Attack.DRIBBLE:
				_change_defender()
			Attack.SHOOT: # , Attack.HEADER
				goal = _check_goal()
				if not goal:
					# TODO emit corner signal for visual action
					corner = _check_corner()
	else:
		foul = _check_foul()
		if foul:
			# TODO emit ponalty/freekick signal for visual action
			var card = _check_card()
			print("Foul with " + card + " card.")
			emit_signal("action_message","Foul with " + card + " card.")
			_check_penalty_or_freekick()
		else:
			kick_in = _check_kick_in()
#		emit_signal("possession_change")
		_change_possession()
		_change_attacker()
	
	if not goal and not corner and not kick_in and not foul:
		current_state = State.NORMAL
	
	
	# increase stats
	match attack:
		Attack.PASS:
			_increase_pass(attack_success)
		Attack.SHOOT:
			_increase_shots(attack_success)


	home_team.update_players()
	away_team.update_players()
	home_stats.update_possession(home_team.has_ball)
	away_stats.update_possession(away_team.has_ball)
	_log(attack, attack_success)
	_action_buffer(attack, attack_success)
	
# returns true if attack wins, false if defense wins
func _get_result(attack):
	# select attributes to use as value for random result calculation
	
	var attacker_attributes = 0
	var defender_attributes = 0
	
	if current_state == State.NORMAL:
		if home_team.has_ball:
			attacker_attributes = home_team.active_player.get_attack_attributes(attack)
			defender_attributes = away_team.active_player.get_defense_attributes(attack)
		else:
			attacker_attributes = away_team.active_player.get_attack_attributes(attack)
			defender_attributes = home_team.active_player.get_defense_attributes(attack)
	else:
		return true
	
	# calculate random action winner
	var max_value = attacker_attributes + defender_attributes
	var random = randi() % int(max_value)
	var result = false
	
	if random < attacker_attributes:
		result = true
	return result
	
func _attack():
	# improve later watching current sector and player attributes
	match current_state:
		State.KICK_OFF, State.KICK_IN:
			return Attack.PASS
		State.PENALTY, State.FREE_KICK, State.PENALTY:
			return Attack.SHOOT
		State.CORNER:
			if randi() % 2 == 0: # use player preferences/attirbutes
				return Attack.CROSS
			else:
				return Attack.PASS
		State.NORMAL:
			var random_attack_factor = randi() % Constants.ATTACK_FACTOR
			if random_attack_factor < Constants.RUN_FACTOR:
				return Attack.RUN
			elif random_attack_factor < Constants.PASS_FACTOR:
				return Attack.PASS
			elif random_attack_factor < Constants.DRIBBLE_FACTOR:
				return Attack.DRIBBLE
			else:
				return Attack.SHOOT

func _log(attack, result):
	emit_signal("action_message","\n" + home_team.active_player.profile["name"] + " vs " + away_team.active_player.profile["name"] + "  ")
	emit_signal("action_message","attack: " + str(Attack.keys()[attack]) + " - defense: " + str(result))

func _action_buffer(attack, result):
	var attacking_player
	var defending_player
	
	if home_team.has_ball:
		attacking_player = home_team.active_player["profile"]["number"]
		defending_player = away_team.active_player["profile"]["number"]
	else:
		attacking_player = away_team.active_player["profile"]["number"]
		defending_player = home_team.active_player["profile"]["number"]
	
	action_buffer.append({
		"action" : Attack.keys()[attack],
		"state" : State.keys()[current_state],
		"is_home" : home_team.has_ball,
		"success" : result,
		"attacking_player" : attacking_player,
		"defending_player" : defending_player,
	})
	
	if action_buffer.size() > MAX_ACTION_BUFFER_SIZE:
		action_buffer.pop_front()

func _check_goal():
	var goalkeeper_attributes
	if home_team.has_ball:
		goalkeeper_attributes = away_team.get_goalkeeper_attributes()
	else:
		goalkeeper_attributes = home_team.get_goalkeeper_attributes()
	
	var random_goal = randi() % int(goalkeeper_attributes)
	
	print(State.keys()[current_state])
	goalkeeper_attributes = goalkeeper_attributes / Constants.GOAL_KEEPER_FACTOR[State.keys()[current_state]]

	if random_goal < goalkeeper_attributes:
		# goal
		if home_team.has_ball:
			emit_signal("action_message","GOAL for " + home_team.name)
			home_stats.increase_goals()
		else:
			emit_signal("action_message","GOAL for " + away_team.name)
			away_stats.increase_goals()
		emit_signal("shot",true, home_team.has_ball)
		_change_possession()
		return true
	else:
		# no goal, but could become shot visual action
		if randi() % Constants.VISUAL_ACTION_SHOTS == 0:
			print("visual action shot, no goal")
			emit_signal("shot", false, home_team.has_ball)
		
	return false
	
	
# ACTION EVENT CHECKS
func _check_corner():
	var random = randi() % Constants.MAX_FACTOR
	if random < Constants.CORNER_AFTER_SAFE_FACTOR:
		current_state = State.CORNER
		_increase_corners()
		return true
	return false
	
func _check_foul():
	var random = randi() % Constants.MAX_FACTOR
	if random < Constants.FOUL_FACTOR:
		_increase_fouls()
		return true
	return false
	
func _check_penalty_or_freekick():
	var random = randi() % Constants.MAX_FACTOR
	if random > Constants.PENALTY_FACTOR:
		current_state = State.FREE_KICK
		_increase_free_kicks()
		emit_signal("action_message","FREE_KICK")
		return true
	else:
		current_state = State.PENALTY
		emit_signal("action_message","PENALTY")
		_increase_penalties()
		return true

	
func _check_card():
	var random = randi() % Constants.MAX_FACTOR
	if random > Constants.RED_CARD_FACTOR:
		_increase_red_cards()
		return "red"
	elif random > Constants.YELLOW_CARD_FACTOR:
		_increase_yellow_cards()
		return "yellow"
	return "no-card"
	
func _check_kick_in():
	var random = randi() % Constants.MAX_FACTOR
	if random < Constants.KICK_IN_FACTOR:
		current_state = State.KICK_IN
		_increase_kick_ins()
		return true
	return false

# PLAYER/POSSESSION CHANGE
func _change_possession():
	home_team.has_ball = not home_team.has_ball
	away_team.has_ball = not away_team.has_ball
	
func _change_players():
	home_team.change_active_player()
	away_team.change_active_player()
	
func _change_defender():
	if home_team.has_ball:
		away_team.change_active_player()
	else:
		home_team.change_active_player()

func _change_attacker():
	if away_team.has_ball:
		away_team.change_active_player()
	else:
		home_team.change_active_player()


# STATISTICS
func _increase_pass(success):
	if away_team.has_ball:
		away_stats.increase_pass(success)
	else:
		home_stats.increase_pass(success)
		
func _increase_shots(on_target):
	print("_increase_shots: " + str(on_target))
	if away_team.has_ball:
		away_stats.increase_shots(on_target)
	else:
		home_stats.increase_shots(on_target)

func _increase_headers(on_target):
	if away_team.has_ball:
		away_stats.increase_headers(on_target)
	else:
		home_stats.increase_headers(on_target)
		
func increase_goals():
	if away_team.has_ball:
		away_stats.increase_goals()
	else:
		home_stats.increase_goals()
		
func _increase_corners():
	if away_team.has_ball:
		away_stats.increase_corners()
	else:
		home_stats.increase_corners()
		
func _increase_kick_ins():
	if away_team.has_ball:
		away_stats.increase_kick_ins()
	else:
		home_stats.increase_kick_ins()

func _increase_fouls():
	if away_team.has_ball:
		home_stats.increase_fouls()
	else:
		away_stats.increase_fouls()
		
func _increase_free_kicks():
	if away_team.has_ball:
		home_stats.increase_free_kicks()
	else:
		away_stats.increase_free_kicks()
		
func _increase_penalties():
	if away_team.has_ball:
		home_stats.increase_penalties()
	else:
		away_stats.increase_penalties()
		
func _increase_red_cards():
	if away_team.has_ball:
		home_stats.increase_red_cards()
	else:
		away_stats.increase_red_cards()
		
func _increase_yellow_cards():
	if away_team.has_ball:
		home_stats.increase_yellow_cards()
	else:
		away_stats.increase_yellow_cards()
