extends Node

var possession_counter = 0.0
var time = 0.0

var statistics = {
	"goals" : 0,
	"possession" : 50,
	"shots" : 0,
	"shots_on_target" : 0,
	"passes" : 0,
	"passes_success" : 0,
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

func update_possession(has_ball) -> void:
	time += 1.0
	if has_ball:
		possession_counter += 1.0
	statistics.possession = (possession_counter / time) * 100

func increase_pass(success) -> void:
	statistics.passes += 1
	if success:
		statistics.passes_success += 1
		
func increase_shots(on_target) -> void:
	statistics.shots += 1
	if on_target:
		statistics.shots_on_target += 1
		
func increase_headers(on_target) -> void:
	statistics.headers += 1
	if on_target:
		statistics.headers_on_target += 1
		
func increase_goals() -> void:
	statistics.goals += 1
	
func increase_corners() -> void:
	statistics.corners += 1
	
func increase_kick_ins() -> void:
	statistics.kick_ins += 1
	
func increase_fouls() -> void:
	statistics.fouls += 1
	
func increase_free_kicks() -> void:
	statistics.free_kicks += 1

func increase_penalties() -> void:
	statistics.penalties += 1

func increase_red_cards() -> void:
	statistics.red_cards += 1
	
func increase_yellow_cards() -> void:
	statistics.yellow_cards += 1
