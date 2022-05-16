extends Node

var possession_counter = 0.0
var time = 0.0

var statistics = {
	"goals" : 0,
	"possession" : 50,
	"shots" : 0,
	"shots_on_target" : 0,
	"pass" : 0,
	"pass_success" : 0,
	"kick_ins" : 0,
	"free_kicks" : 0,
	"penalties" : 0,
	"penalty_kick" : 0, # after 6 fouls
	"fouls" : 0,
	"tackles" : 0,
	"tackles_success" : 0,
	"corners" : 0,
	"headers" : 0,
	"headers_on_target" : 0,
	"yellow_cards" : 0,
	"red_cards" : 0
}

func update_possession(has_ball):
	time += 1.0
	if has_ball:
		possession_counter += 1.0
	statistics.possession = (possession_counter / time) * 100

func increase_pass(success):
	statistics.pass += 1
	if success:
		statistics.pass_success += 1
		
func increase_shots(on_target):
	statistics.shots += 1
	if on_target:
		statistics.shots_on_target += 1
		
func increase_headers(on_target):
	statistics.headers += 1
	if on_target:
		statistics.headers_on_target += 1
		
func increase_goals():
	statistics.goals += 1
	
func increase_corners():
	statistics.corners += 1
	
func increase_kick_ins():
	statistics.kick_ins += 1
	
func increase_fouls():
	statistics.fouls += 1
	
func increase_free_kicks():
	statistics.free_kicks += 1

func increase_penalties():
	statistics.penalties += 1

func increase_red_cards():
	statistics.red_cards += 1
	
func increase_yellow_cards():
	statistics.yellow_cards += 1
