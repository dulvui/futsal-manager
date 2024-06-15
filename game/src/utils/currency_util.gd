# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Currencies { EURO, DOLLAR, POUND, BITCOIN }

const SIGNS: Array = ["€", "$", "£", "₿"]


func convert_to() -> int:
	return 0


func get_sign(amount: int) -> String:
	return str(amount) + " " + SIGNS[Config.currency]
