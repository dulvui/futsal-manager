extends Node

const Player = preload("res://src/utils/match-simulator/simulator-player/SimulatorPlayer.gd")


enum states {
	DEFENDING,ATTACKING,KICKOFF,
	CORNER,KICKIN,FREEKICK,PENALTY,
	SIXFOUL,ENTER_FIELD,EXIT_FIELD,
	SUBSTITUTION,INJURY,RED_CARD # might move some to players like red card
}

var state

var players = []
var opponent_players = []

var player_control
var player_receive
var player_support
var player_closest_to_ball

var distance_player_closest_to_ball

func set_up(home_players,away_players,formation):
	for i in home_players.size():
		var player = Player.new()
		player.set_up(home_players[i],i,formation)
		players.append(player)
	for i in away_players.size():
		var player = Player.new()
		player.set_up(away_players[i],i,formation)
		players.append(player)
	

func update():
	for player in players:
		player.update()
	
#	  //this information is used frequently so it's more efficient to 
#  //calculate it just once each frame
#  CalculateClosestPlayerToBall();
#
#  //the team state machine switches between attack/defense behavior. It
#  //also handles the 'kick off' state where a team must return to their
#  //kick off positions before the whistle is blown
#  m_pStateMachine->Update();
#
#  //now update each player
#  std::vector<PlayerBase*>::iterator it = m_Players.begin();
#
#  for (it; it != m_Players.end(); ++it)
#  {
#    (*it)->Update();
#  }

func create_player():
	pass

# Called when the node enters the scene tree for the first time.
func update_wait_players():
	pass

# checks if player_control is in hot zone or has free sight to goal
func can_shot():
	pass


# checks if a player is in range and has free sight
func can_pass():
	pass
	
func is_pass_safe():
	pass
	
func find_pass(): # finds the player who to pass
	pass

# checks if pass direclty to players or on border of bounding circle
func get_best_pass_destination():
	pass
	
func is_opponent_within_radius():
	pass
	
func request_pass():
	pass
	
func count_players_at_home():
	pass
	

