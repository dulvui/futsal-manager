extends Node


enum states {ATTACK,DEFEND,SUPPORT,WAIT,FREE_KICK, HOME}
# saves the player info with stats, name etc
var info

var position

var home_region
var attack_region
var defend_region

var formation # json, also saves tatcitcs in it

var role

func set_up(player, formation, role): # formation also includes tactics
	info = player
	set_regions()

func update():
	# check state machine
	pass

func change_tactic(new_formation):
	formation = new_formation
	set_regions()
	

func set_regions():
	home_region = formation["home_regions"][role]
	attack_region = formation["attack_regions"][role]
	defend_region = formation["defend_regions"][role]
