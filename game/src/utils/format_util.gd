# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum Currencies { EURO, DOLLAR, POUND, BITCOIN }

const SIGNS: Array = ["€", "$", "£", "₿"]


func get_sign(amount: int) -> String:
	return str(amount) + " " + SIGNS[Global.currency]


func format_date(p_date: Dictionary) -> String:
	return (
		tr(Const.DAY_STRINGS[p_date.weekday])
		+ " "
		+ tr(str(p_date.day))
		+ " "
		+ tr(Const.MONTH_STRINGS[p_date.month - 1])
		+ " "
		+ str(p_date.year)
	)
