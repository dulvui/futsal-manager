extends Node

signal home_goal
signal away_goal
signal home_pass
signal away_pass

const Player = preload("res://src/utils/match-simulator/simulator-player/SimulatorPlayer.gd")

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

var sectors = [
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	},
	{
		"home_players" : [],
		"away_players" : [],
	}
]

var time = 0.0

var home_possess_counter = 0.0

var home_has_ball

var action_buffer = []


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
	
func update():
	time += 1
	if home_has_ball:
		home_possess_counter += 1
	home_stats["possession"] = (home_possess_counter / time) * 100
	away_stats["possession"] = 100 - home_stats["possession"]
	
	var player_has_ball = 0
	
	# add pos to update_decision
	for player in home_team["players"]["active"]:
		player["real"].update_decision(home_has_ball,player["has_ball"])
		
		if player["real"].player["has_ball"]:
			print("PLAYER " + player["surname"] + " HAS BALL")
			player_has_ball += 1
		
	for player in away_team["players"]["active"]:
		player["real"].update_decision(!home_has_ball,player["has_ball"])
		
		if player["real"].player["has_ball"]:
			print("PLAYER " + player["surname"] + " HAS BALL")
			player_has_ball += 1
			
	if player_has_ball == 0:
		print("no Player has ball")
		
	if player_has_ball == 2:
		print("2 Players has ball")
		
	update_field_players()
		


func get_team_players_in_sector(home,sector_pos):
	if home:
		return sectors[sector_pos/200]["home_players"]
	else:
		return sectors[sector_pos/200]["away_players"]
	
				
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

func update_field_players():
	$HomePlayers/G.move_to(home_team["players"]["active"][0]["real"].current_pos)
	if home_team["players"]["active"][0]["real"].player["has_ball"]:
		$Ball.move_to($HomePlayers/G.position)
	$HomePlayers/D.move_to(home_team["players"]["active"][1]["real"].current_pos)
	if home_team["players"]["active"][1]["real"].player["has_ball"]:
		$Ball.move_to($HomePlayers/D.position)
	$HomePlayers/WL.move_to(home_team["players"]["active"][2]["real"].current_pos)
	if home_team["players"]["active"][2]["real"].player["has_ball"]:
		$Ball.move_to($HomePlayers/WL.position)
	$HomePlayers/WR.move_to(home_team["players"]["active"][3]["real"].current_pos)
	if home_team["players"]["active"][3]["real"].player["has_ball"]:
		$Ball.move_to($HomePlayers/WR.position)
	$HomePlayers/P.move_to(home_team["players"]["active"][4]["real"].current_pos)
	if home_team["players"]["active"][4]["real"].player["has_ball"]:
		$Ball.move_to($HomePlayers/P.position)
	
	$AwayPlayers/G.move_to(away_team["players"]["active"][0]["real"].current_pos)
	if away_team["players"]["active"][0]["real"].player["has_ball"]:
		$Ball.move_to($AwayPlayers/G.position)
	$AwayPlayers/D.move_to(away_team["players"]["active"][1]["real"].current_pos)
	if away_team["players"]["active"][1]["real"].player["has_ball"]:
		$Ball.move_to($AwayPlayers/D.position)
	$AwayPlayers/WL.move_to(away_team["players"]["active"][2]["real"].current_pos)
	if away_team["players"]["active"][2]["real"].player["has_ball"]:
		$Ball.move_to($AwayPlayers/WL.position)
	$AwayPlayers/WR.move_to(away_team["players"]["active"][3]["real"].current_pos)
	if away_team["players"]["active"][3]["real"].player["has_ball"]:
		$Ball.move_to($AwayPlayers/WR.position)
	$AwayPlayers/P.move_to(away_team["players"]["active"][4]["real"].current_pos)
	if away_team["players"]["active"][4]["real"].player["has_ball"]:
		$Ball.move_to($AwayPlayers/P.position)
	
func create_real_player(player,pos):
	var real_player = Player.new()
	match pos:
		0:
			real_player.set_up(player,Vector2(100,300),pos)
		1:
			real_player.set_up(player,Vector2(250,300),pos)
		2:
			real_player.set_up(player,Vector2(350,400),pos)
		3:
			real_player.set_up(player,Vector2(350,500),pos)
		4:
			real_player.set_up(player,Vector2(500,300),pos)
				
	real_player.connect("pass_to",self,"pass_to")
	real_player.connect("shoot",self,"shoot")
	real_player.connect("dribble",self,"dribble")
	add_child(real_player)
	return real_player

func pass_to(player):
	print(player["name"])
	print("PASS in sim")
	
	
	
func shoot(player):
	print(player["name"])
	print("SHOOTS in sim")
	player["real"].player["has_ball"] = false
	
	var shoot_blocked = false
	
	if player["home"]:
		home_stats["shots"] += 1
	else:
		away_stats["shots"] += 1
		
	for sector_index in range(player["real"].current_sector,12):
		var opponent_players
		if player["home"]:
			opponent_players = sectors[sector_index]["away_players"]
		else:
			opponent_players = sectors[sector_index]["home_players"]
		opponent_players.shuffle()
		
		if opponent_players.size() > 0:
			var random_defender = opponent_players[0]

			var defense_factor:int = random_defender["technical"]["intercept"] # use block_shots
			var shoot_factor:int = player["technical"]["shoot_power"] * 5
			var intercept_factor:int = defense_factor + shoot_factor
			
			var random_factor = randi()%intercept_factor
			var intercept_result = random_factor < defense_factor
			
			if intercept_result:
				print("SHOOT BLOCKED")
				shoot_blocked = true
				random_defender["real"].player["has_ball"] = true
				if player["home"]:
					home_has_ball = false
				else:
					home_has_ball = true
				break
				
	if not shoot_blocked:
		print("SHOOT NOT BLOCKED")
		
		var shoot_precision_factor: int = player["technical"]["shoot_precision"]
		var tollerance = 5
		
		var on_target_factor = shoot_precision_factor + tollerance
		
		var on_target_result = randi()%on_target_factor
		if on_target_result < shoot_precision_factor:
			print("SHOOT ON TARGET")
			var finishing_factor: int = player["technical"]["finishing"]
			var goalkeeper_factor: int
			
			if player["home"]:
				home_stats["shots_on_target"] += 1
				goalkeeper_factor = home_team["players"]["active"][0]["technical"]["intercept"] # change with goalie stats
			else:
				away_stats["shots_on_target"] += 1
				goalkeeper_factor = away_team["players"]["active"][0]["technical"]["intercept"]
			
			var goal_factor = randi()%(finishing_factor + goalkeeper_factor)
			if goal_factor < finishing_factor:
				if player["home"]:
					emit_signal("home_goal")
					print("HOME GOAL")
					show_goal(player)
					home_stats["goals"] += 1
					home_has_ball = false
					away_team["players"]["active"][4]["real"].player["has_ball"] = true
				else:
					emit_signal("away_goal")
					print("AWAY GOAL")
					show_goal(player)
					away_stats["goals"] += 1
					home_has_ball = true
					home_team["players"]["active"][4]["real"].player["has_ball"] = true
				get_tree().call_group("simulator_player","kick_off")
				$Ball.kick_off()
			else:
				if player["home"]:
					home_has_ball = false
					away_team["players"]["active"][0]["real"].player["has_ball"] = true
				else:
					home_has_ball = true
					home_team["players"]["active"][0]["real"].player["has_ball"] = true
		else:
			print("SHOOT OFF TARGET")
			if player["home"]:
				home_has_ball = false
				away_team["players"]["active"][0]["real"].player["has_ball"] = true
			else:
				home_has_ball = true
				home_team["players"]["active"][0]["real"].player["has_ball"] = true
			

	
func move_up(player):
#	print(player["name"])
#	print("MOVES UP in sim")
	pass

func move_down(player):
#	action_buffer.append(player,"DRIBBLE")
	pass
	
func wait(player):
#	action_buffer.append(player,"WAIT")
	pass
	
func dribble(player):
#	action_buffer.append(player,"DRIBBLE")
	pass


func show_goal(player):
	pass
	
func add_action(player,current_action):
	var action = {"player":player,"action" :current_action}
#	action_buffer.append(action)
	if action_buffer.size()>10:
		action_buffer.pop_front()
