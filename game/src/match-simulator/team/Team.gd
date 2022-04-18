extends Node2D

const Player = preload("res://src/match-simulator/team/player/Player.tscn")


enum Mentality {ULTRA_OFFENSIVE, OFFENSIVE, NORMAL, DEFENSIVE, ULTRA_DEFENSIVE}
enum Passing {LONG, SHORT, DIRECT, NORMAL}
enum Formations {TT=22,OTO=121,OOT=112,TOO=211,TO=31,OT=13}


var players = []

var statistics = {
	"goals" : 0,
	"possession" : 50,
	"shots" : 0,
	"shots_on_target" : 0,
	"pass" : 0,
	"pass_success" : 0,
	"free_kicks" : 0,
	"penalty" : 0,
	"penalty_kick" : 0, # after 6 fouls
	"fouls" : 0,
	"tackles" : 0,
	"tackles_success" : 0,
	"corners" : 0,
	"headers" : 0,
	"headers_success" : 0,
	"yellow_cards" : 0,
	"red_cards" : 0
}

# trainer tactics settings
var tactics = {
	"formation" : Formations.TT,
	"mentality" : Mentality.NORMAL,
	"pressing" : false,
	"counter_attack" : false,
	"passing" : Passing.NORMAL,
}

# to calculate possession
var possession_counter = 0.0

var has_ball = false

# player that is attacking/defending
var active_player

func set_up(team): # TODO add tactics
	var team_players = team["players"]["active"]
	for team_player in team_players:
		var player = Player.instance()
		player.set_up(team_player)
		players.append(player)

	active_player = players[-1]
	
func update_possession(time):
	if has_ball:
		possession_counter += 1.0
	statistics.possession = (possession_counter / time) * 100
	
func increase_pass(success):
	statistics.pass += 1
	if success:
		statistics.pass_success += 1
	
	
func update_players():
	for player in players:
		player.update()

func change_active_player():
	var other_players = players.duplicate()
	other_players.remove(players.find(active_player))
	
	active_player = other_players[(randi() % 3) + 1]
