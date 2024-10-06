# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var rng: RandomNumberGenerator
var match_rng: RandomNumberGenerator


func set_up_rngs() -> void:
	match_rng = RandomNumberGenerator.new()
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Config.generation_seed) + Config.generation_player_names
	rng.state = Config.generation_state


func reset_seed(p_generation_seed: String, p_generation_player_names: int) -> void:
	Config.generation_seed = p_generation_seed
	Config.generation_player_names = p_generation_player_names
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Config.generation_seed + str(Config.generation_player_names))
	Config.generation_state = rng.state


# shuffle array using global RuandomNumberGenerator
func shuffle(array: Array[Variant]) -> void:
	for i in array.size():
		var index: int = rng.randi_range(0, array.size() - 1)
		if index != i:
			var temp: Variant = array[index]
			array[index] = array[i]
			array[i] = temp

# shuffle array using global RuandomNumberGenerator
func pick_random(array: Array[Variant]) -> Variant:
	return array[rng.randi() % array.size() - 1]
