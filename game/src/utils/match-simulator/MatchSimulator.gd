extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

const Player = preload("res://src/screens/match/field/player/Player.tscn")

var home_team = {}
var away_team = {}

var home_stats = {
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
	"throw_in" : 0, #rimessa
	"yellow_cards" : 0,
	"red_cards" : 0
}
var away_stats = {
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
	"throw_in" : 0, #rimessa
	"yellow_cards" : 0,
	"red_cards" : 0
}

const SECTOR_SIZE = 200

var time = 0.0

var home_possess_counter = 0.0

var home_has_ball

func _ready():
	pass
	
func update():
	time += 1
	if home_has_ball:
		home_possess_counter += 1
	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]
	
	
	# add pos to update_decision
	for player in home_team["players"]["active"]:
		player["real"].update_decision(home_has_ball,player["has_ball"])
		
	for player in away_team["players"]["active"]:
		player["real"].update_decision(!home_has_ball,player["has_ball"])

func set_up(home,away, match_started):
	home_team = home.duplicate(true)
	away_team = away.duplicate(true)
	
	for i in range(home_team["players"]["active"].size()):
		var player = home_team["players"]["active"][i]
		player["has_ball"]  = false
		player["home"]  = true # change on halftime
		player["real"] = create_real_player(player,i)

	for i in range(away_team["players"]["active"].size()):
		var player = away_team["players"]["active"][i]
		player["has_ball"]  = false
		player["home"]  = false
		player["real"] = create_real_player(player,i)

	if match_started:
		home_has_ball = randi()%2 == 0
		if home_has_ball:
			home_team["players"]["active"][4]["has_ball"] = true
		else:
			away_team["players"]["active"][4]["has_ball"] = true

func get_team_players_in_sector(home,sector_pos):
	var team_players = []
	if home:
		var current_sector = sector_pos / SECTOR_SIZE
		for player in home_team["players"]["active"]:
			if player["real"].sector_pos / SECTOR_SIZE == current_sector:
				team_players.append(player)
	else:
		var current_sector = 6 - (sector_pos / SECTOR_SIZE)
		for player in away_team["players"]["active"]:
			if player["real"].sector_pos / SECTOR_SIZE == current_sector:
				team_players.append(player)
				
	return team_players
	
func get_sector_with_most_opponent_players(home,sector_pos):
	var team_players = []
	if home:
		var current_sector = sector_pos / SECTOR_SIZE
		for player in home_team["players"]["active"]:
			if player["real"].sector_pos / SECTOR_SIZE == current_sector:
				team_players.append(player)
	else:
		var current_sector = 12 - (sector_pos / SECTOR_SIZE)
		for player in away_team["players"]["active"]:
			if player["real"].sector_pos / SECTOR_SIZE == current_sector:
				team_players.append(player)
				
	return team_players
	
				
func change_players(new_home_team,new_away_team):
	home_team = new_home_team.duplicate(true)
	away_team = new_away_team.duplicate(true)
	
	for i in range(home_team["players"]["active"].size()):
		var player = home_team["players"]["active"][i]
		player["has_ball"]  = false
		player["home"]  = true
		player["real"] = create_real_player(player,i)

	for i in range(away_team["players"]["active"].size()):
		var player = away_team["players"]["active"][i]
		player["has_ball"]  = false
		player["home"]  = false
		player["real"] = create_real_player(player,i)
	
	
	#make better and look who has ball after interruption
	home_has_ball = randi()%2 == 0
	if home_has_ball:
		home_team["players"]["active"][4]["has_ball"] = true
	else:
		away_team["players"]["active"][4]["has_ball"] = true



func create_real_player(player,i):
	var real_player = Player.instance()
	real_player.set_up(player,i)
	real_player.connect("pass_to",self,"pass_to")
	real_player.connect("shoot",self,"shoot")
	real_player.connect("move_up",self,"move_up")
	real_player.connect("move_down",self,"move_up")
	real_player.connect("wait",self,"wait")
	real_player.connect("dribble",self,"dribble")
	add_child(real_player)
	return real_player

func pass_to(player):
	print(player["name"])
	print("PASS in sim")
	
func shoot(player):
	print(player["name"])
	print("PASS in sim")

func move_up(player):
	print(player["name"])
	print("MOVES UP in sim")

func move_down(player):
	print(player["name"])
	print("MOVES DOWN in sim")
	
func wait(player):
	print(player["name"])
	print("WAITS in sim")
	
func dribble(player):
	print(player["name"])
	print("DRIBBLES in sim")

