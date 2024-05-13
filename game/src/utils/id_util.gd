# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Types {LEAGUE, TEAM, PLAYER, MANAGER, TRANSFER, CONTRACT, EMAIL, MATCH}

# max int value is 9223372036854775807, so quite safe to use
func next_id(type:Types) -> int:
	if not Config.state:
		return -1
	
	var type_key:String = Types.keys()[type]
	if type_key not in Config.state.id_by_type:
		Config.state.id_by_type[type_key] = 0
	Config.state.id_by_type[type_key] += 1
	return Config.state.id_by_type[type_key]
