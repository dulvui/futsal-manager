# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Action

enum State { NORMAL, KICK_OFF, PENALTY, FREE_KICK, KICK_IN, CORNER }
enum Defense { INTERCEPT, WAIT, TACKLE, RUN, BLOCK, HEADER }
enum Attack { PASS, CROSS, DRIBBLE, RUN, SHOOT }

# in which sector of the field the player is situated
# so better decisions can be made depeneding on the sector a player is
enum Sector { ATTACK, CENTER, DEFENSE }

var attack: int
var state: int
var is_home: bool
var success: bool
var attacking_player: Player
var defending_player: Player
