extends Node2D

const Player = preload("res://src/match-simulator/team/player/Player.tscn")


enum Mentality {ULTRA_OFFENSIVE, OFFENSIVE, NORMAL, DEFENSIVE, ULTRA_DEFENSIVE}
enum Passing {LONG, SHORT, DIRECT, NORMAL}
enum Formations {TT=22,OTO=121,OOT=112,TOO=211,TO=31,OT=13}


var players = []

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
	
func update_players():
	for player in players:
		player.update()

func change_active_player():
	var other_players = players.duplicate()
	other_players.remove(players.find(active_player))
	
	active_player = other_players[(randi() % 3) + 1]

