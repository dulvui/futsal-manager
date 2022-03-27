extends Node2D

enum Mentality {ULTRA_OFFENSIVE, OFFENSIVE, NORMAL, DEFENSIVE, ULTRA_DEFENSIVE}
enum Passing {LONG, SHORT, DIRECT, NORMAL}
enum Formations {TT=22,OTO=121,OOT=112,TOO=211,TO=31,OT=13}


onready var goalkeeper = $Goalkeeper
onready var player1 = $Player1
onready var player2 = $Player2
onready var player3 = $Player3
onready var player4 = $Player4

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
var possession_counter = 0

var has_ball = false

# player that is attacking/defending
var active_player

func set_up(): # TODO add tactics
	goalkeeper.set_up(has_ball)
	# role will be replaced with formations positions
	player1.set_up(has_ball,Player.Role.DEFENSE)
	player2.set_up(has_ball,Player.Role.DEFENSE)
	player3.set_up(has_ball,Player.Role.CENTER)
	player4.set_up(has_ball,Player.Role.ATTACK)
	
	# always start with attackers as active player
	active_player = player4
	

func update_stats(time):
	if has_ball:
		possession_counter += 1
	statistics.possession = (possession_counter / time) * 100
	
func update_players():
	goalkeeper.update()
	player1.update()
	player2.update()
	player3.update()
	player4.update()

