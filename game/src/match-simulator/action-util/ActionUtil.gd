# Action util that handles every action of the game.
# First the player with the ball attacks and the corresponding player of
# the other team reposonds with a defense action and accordign to individual
# player attributes and team tactics a result gets calculated.

extends Node

signal possession_change
# goal signals for visual actions
signal home_goal
signal away_goal
signal nearly_goal

class_name ActionUtil

# in which sector of the field the player is situated
# so better decisions can be made depeneding on the sector a player is
enum Sector {ATTACK, CENTER, DEFENSE}
enum Attack {PASS, DRIBBLE, RUN, SHOOT, CROSS, HEADER}
enum Defense {INTERCEPT, WAIT, TACKLE, RUN, BLOCK, HEADER}
enum State {NORMAL, KICK_OFF, PENALTY, FREE_KICK, KICK_IN, CORNER}

onready var log_richtext = get_node("../Log")


onready var home_team = $HomeTeam
onready var away_team = $AwayTeam

onready var home_stats = $HomeStatistics
onready var away_stats = $AwayStatistics

var current_state

func _ready():
	randomize()

func set_up(_home_team, _away_team):
	home_team.set_up(_home_team)
	
	away_team.set_up(_away_team)

	current_state = State.KICK_OFF


func update(time):
	var attack = _attack()
	
	var result = _get_result(attack)
	
	var goal = false
	
	# change active players and possession
	if result:
		match attack:
			Attack.PASS, Attack.CROSS:
				_change_players()
			Attack.RUN, Attack.DRIBBLE:
				_change_defender()
			Attack.SHOOT, Attack.HEADER:
				var goalkepper_attributes
				if home_team.has_ball:
					goalkepper_attributes = away_team.get_goalkeeper_attributes()
				else:
					goalkepper_attributes = home_team.get_goalkeeper_attributes()
				
				var random_goal = randi() % int(goalkepper_attributes)
				if random_goal < goalkepper_attributes / Constants.GOAL_KEEPER_FACTOR:
					goal = true
					if home_team.has_ball:
						home_stats.increase_goals()
						emit_signal("home_goal")
					else:
						away_stats.increase_goals()
						emit_signal("away_goal")
	else:
		emit_signal("possession_change")
		_change_possession()
		_change_attacker()
		
	# increase stats
	match attack:
		Attack.PASS:
			_increase_pass(result)
		Attack.SHOOT:
			_increase_shots(result)
		Attack.HEADER:
			_increase_headers(result)
	
	_update_current_state(goal)
	
	# add random occurencies like corners, fouls etc...
	
	# if shoot and no interception, goalkepper needs to safe
	
	home_team.update_players()
	away_team.update_players()
	
	home_stats.update_possession(home_team.has_ball)
	away_stats.update_possession(away_team.has_ball)
	
	_log(attack, result)

	
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
		State.KICK_OFF:
			return Attack.PASS
		State.PENALTY, State.FREE_KICK, State.PENALTY:
			return Attack.SHOOT
		State.CORNER:
			if randi() % 2 == 0: # use player preferences/attirbutes
				return Attack.CROSS
			else:
				return Attack.PASS
		State.NORMAL:
			return Attack.values()[randi() % Attack.size()]


func _defend(attack):
	match current_state:
		State.KICK_OFF:
			return Defense.WAIT
		State.PENALTY, State.FREE_KICK, State.PENALTY:
			return Defense.WAIT
		State.CORNER:
			return Defense.INTERCEPT
		State.NORMAL:
			match attack:
				Attack.SHOOT:
					return Defense.BLOCK
				Attack.CROSS,Attack.PASS:
					return Defense.INTERCEPT
				Attack.DRIBBLE:
					return Defense.TACKLE
				Attack.HEADER:
					return Defense.HEADER
				Attack.RUN:
					if randi() % 2 == 0: # use player preferences/attirbutes
						return Defense.RUN
					else:
						return Defense.TACKLE
				Attack.WAIT:
					return Defense.WAIT


func _update_current_state(goal):
	if goal:
		current_state = State.KICK_OFF
	else:
		match current_state:
			State.KICK_OFF, State.CORNER, State.FREE_KICK, State.PENALTY:
				current_state = State.NORMAL


func _log(attack, result):
#	print(State.keys()[current_state])
#	print(home_team.active_player.profile["name"] + " vs " + away_team.active_player.profile["name"])
#	print("attack: " + str(Attack.keys()[attack]) + " - defense: ")
#	print(result)
	
	log_richtext.add_text("\n" + home_team.active_player.profile["name"] + " vs " + away_team.active_player.profile["name"] + "  ")
	log_richtext.add_text("attack: " + str(Attack.keys()[attack]) + " - defense: " + str(result))

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
		
func _increase_pass(success):
	if away_team.has_ball:
		away_stats.increase_pass(success)
	else:
		home_stats.increase_pass(success)
		
func _increase_shots(on_target):
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
