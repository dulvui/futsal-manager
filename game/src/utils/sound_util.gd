# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

func _ready() -> void:
    var buttons: Array = get_tree().get_nodes_in_group("Button")
    for inst in buttons:
        inst.connect("pressed", self, "on_button_pressed")

func on_button_pressed()->void:
    button_sound.play()
