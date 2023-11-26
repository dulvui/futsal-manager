# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name PlayerProgress

const NOISE = 20
const AGE_PHYSICAL_DEGARDE = 30

static func update_players() -> void:
	for league in Config.leagues:
		for team in league.teams:
			for player in team.players:
				_season_progress(player)
				

static func _season_progress(player:Player) -> void:
	# add random noise
	var prestige_factor:int = player.prestige + randi_range(-NOISE, NOISE)
	# age factor only affects fisical attributes neagtively
	# high prestige player has smaller age factor, that means his physical attributes
	# dergade less and later 
	var age:int = Config.date.year - player.birth_date.year
	
	# -1/+1 depending on player age and prestige
	var age_factor:int = AGE_PHYSICAL_DEGARDE - age + (player.prestige / 12)
	if age_factor < 0:
		age_factor = -1
	else:
		age_factor = 1
	
	# check bounds prestige_factor
	if prestige_factor < 1:
		prestige_factor = 1
	if prestige_factor > Constants.MAX_PRESTIGE:
		prestige_factor = Constants.MAX_PRESTIGE
		
	# increment all atrtibutes from 0 to 3
	
	# mental
	for attribute in player.attributes.mental.get_property_list():
		if attribute.usage == 4102: # custoom properties 
			# random value from 0 to 300
			var value:int = randi_range(1, Constants.MAX_PRESTIGE) + randi_range(1, prestige_factor) + prestige_factor
			value /= 100
			player.attributes.mental[attribute.name] = min(player.attributes.mental[attribute.name] + value, 20)
	
	# physical
	for attribute in player.attributes.physical.get_property_list():
		if attribute.usage == 4102: # custoom properties 
			var value:int = randi_range(1, Constants.MAX_PRESTIGE) + randi_range(1, prestige_factor) + prestige_factor
			value /= 100 * age_factor
			player.attributes.physical[attribute.name] = min(player.attributes.physical[attribute.name] + value, 20)
	
	# technical
	for attribute in player.attributes.technical.get_property_list():
		if attribute.usage == 4102: # custoom properties 
			var value:int = randi_range(1, Constants.MAX_PRESTIGE) + randi_range(1, prestige_factor) + prestige_factor
			value /= 100
			player.attributes.technical[attribute.name] = min(player.attributes.technical[attribute.name] + value, 20)
	
	#goalkeeper
	for attribute in player.attributes.goalkeeper.get_property_list():
		if attribute.usage == 4102: # custoom properties 
			var value:int = randi_range(1, Constants.MAX_PRESTIGE) + randi_range(1, prestige_factor) + prestige_factor
			value /= 100 * age_factor
			player.attributes.goalkeeper[attribute.name] = min(player.attributes.goalkeeper[attribute.name] + value, 20)
