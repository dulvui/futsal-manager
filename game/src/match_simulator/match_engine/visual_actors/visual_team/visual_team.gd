extends Node2D

var goalkeeper:VisualGoalkeeper = $VisualGoalkeeper
var player1:VisualPlayer = $VisualPlayer1
var player2:VisualPlayer = $VisualPlayer2
var player3:VisualPlayer = $VisualPlayer3
var player4:VisualPlayer = $VisualPlayer4
var player5:VisualPlayer = $VisualPlayer5



func set_up(sim_team:SimTeam) -> void:
	goalkeeper.set_up(sim_team.goalkeeper)
	player1.set_up(sim_team.players[0])
	player2.set_up(sim_team.players[1])
	player3.set_up(sim_team.players[2])
	player4.set_up(sim_team.players[3])
	player5.set_up(sim_team.players[4])
