# Action util that handles every action of the game.
# First the player with the ball attacks and the corresponding player of
# the other team reposonds with a defense action and accordign to individual
# player attributes and team tactics a result gets calculated.

extends Node

signal possession_change
signal goal
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

var current_state

func _ready():
	randomize()

func set_up(_home_team, _away_team):
	home_team.set_up(_home_team)
	
	away_team.set_up(_away_team)

	current_state = State.KICK_OFF


func update():
	var attack = _attack()
	
	var result = _get_result(attack)
	
	if result:
		match attack:
			Attack.PASS, Attack.CROSS:
				_change_players()
			Attack.RUN, Attack.DRIBBLE:
				_change_defending_player()
	else:
		emit_signal("possession_change")
		_change_possession()
		_change_attacking_player()
	
	_update_current_state(result)
	
	# add random occurencies like corners, fouls etc...
	
	# if shoot and no interception, goalkepper needs to safe
	
	home_team.update_players()
	away_team.update_players()
	
	_log(attack, result)

	
# returns true if attack wins, false if defense wins
func _get_result(attack):
	# select attributes to use as value for random result calculation
	
	var attacking_player
	var defending_player
	
	var attacking_player_attributes = 0
	var defending_player_attributes = 0
	
	if home_team.has_ball:
		attacking_player = home_team.active_player
		defending_player = away_team.active_player
	else:
		attacking_player = away_team.active_player
		defending_player = home_team.active_player
	
	
	if current_state == State.NORMAL:
		match attack:
			Attack.SHOOT:
				# check sector and pick long_shoot
				attacking_player_attributes = attacking_player.attributes["technical"]["shooting"]
				defending_player_attributes = defending_player.attributes["technical"]["blocking"]
			Attack.PASS:
				attacking_player_attributes = attacking_player.attributes["technical"]["passing"]
				defending_player_attributes = defending_player.attributes["technical"]["interception"]
			Attack.CROSS:
				attacking_player_attributes = attacking_player.attributes["technical"]["crossing"]
				defending_player_attributes = defending_player.attributes["technical"]["interception"]
			Attack.DRIBBLE:
				attacking_player_attributes = attacking_player.attributes["technical"]["dribbling"]
				defending_player_attributes = defending_player.attributes["technical"]["tackling"]
			Attack.HEADER:
				attacking_player_attributes = attacking_player.attributes["technical"]["heading"]
				defending_player_attributes = defending_player.attributes["technical"]["heading"]
			# use player preferences/attirbutes and team tactics pressing or wait
			Attack.RUN:
				attacking_player_attributes = attacking_player.attributes["physical"]["pace"]
				attacking_player_attributes += attacking_player.attributes["physical"]["acceleration"]
				if randi() % 2 == 0: 
#					return Defense.RUN
					defending_player_attributes = attacking_player.attributes["physical"]["pace"]
					defending_player_attributes += attacking_player.attributes["physical"]["acceleration"]
				else:
#					return Defense.TACKLE
					defending_player_attributes = attacking_player.attributes["technical"]["tackling"]
					defending_player_attributes += attacking_player.attributes["physical"]["balance"]
#			Attack.WAIT:
#				return Defense.WAIT
	else:
		return true
	
	# calculate random winner
	var max_value = attacking_player_attributes + defending_player_attributes
	
	var random = randi() % max_value
	
	if random < attacking_player_attributes:
		return true
	return false
	
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


func _update_current_state(result):
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
	
func _change_defending_player():
	if home_team.has_ball:
		away_team.change_active_player()
	else:
		home_team.change_active_player()

func _change_attacking_player():
	if away_team.has_ball:
		away_team.change_active_player()
	else:
		home_team.change_active_player()
