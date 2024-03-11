# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Types {LEAGUE, TEAM, PLAYER, MANAGER, TRANSFER, EMAIL}

func next_id(type:Types) -> int:
	var type_key:String = Types.keys()[type]
	if type_key not in Config.id_by_type:
		Config.id_by_type[type_key] = 0
	Config.id_by_type[type_key] += 1
	return Config.id_by_type[type_key]
